# Intermittent AMDGPU fence fallback and GLES bounds errors on Niri

## Summary

On NixOS, Niri intermittently causes a visible desktop stutter and this kernel message:

```text
amdgpu 0000:71:00.0: Fence fallback timer expired on ring gfx_0.1.0
```

The issue is sporadic: it may be absent for tens of minutes, but can also occur repeatedly. It is most reproducible after the desktop has been idle and YouTube playback is started, usually within a few seconds. Typing or rapidly updating a terminal can also trigger it. There are no crashes, GPU resets, artifacts, page faults, or AER errors; the visible symptom is a brief desktop stutter.

Niri also logs invalid GLES texture uploads at times:

```text
[GL] GL_INVALID_VALUE in glTexSubImage2D(xoffset 0 + width 1763 > 919)
[GL] GL_INVALID_VALUE in glTexSubImage2D(xoffset 0 + width 1342 > 919)
[GL] GL_INVALID_VALUE in glTexSubImage2D(xoffset 0 + width 1677 > 833)
```

The combination and the compositor comparison below suggest a Niri/Smithay interaction with the AMDGPU renderer, although an AMDGPU/kernel/firmware issue exposed by Niri cannot be ruled out.

## Hardware and software

- Board: MSI MAG X870 TOMAHAWK WIFI (MS-7E51)
- BIOS: 1.A92, 2026-06-30
- CPU: AMD Ryzen 9 9900X 12-Core Processor
- AMD GPU: Granite Ridge/Radeon Graphics, `1002:13c0`, BDF `0000:71:00.0`, `amdgpu`
- AMDGPU-reported VRAM: 512 MiB; GTT: approximately 15.5 GiB
- NVIDIA GPU: BDF `0000:01:00.0`, proprietary open kernel module, driver `610.57.04`
- OS: NixOS unstable
- Kernels tested: `7.1.2` and `7.2.0 #1-NixOS SMP PREEMPT_DYNAMIC`
- Mesa/radeonsi: `26.1.6.0`
- DRM: `3.64`
- NixOS effective Xorg drivers: `nvidia`, `modesetting`
- NVIDIA configuration: PRIME render offload; AMD owns the displays when BIOS is set to IGD
- Niri version: **[please fill in with `niri --version`]**

The monitor has been tested through the motherboard’s USB-C-to-DisplayPort output and HDMI output. Both can reproduce the issue; HDMI made the stutter less obvious at a lower mode but did not eliminate the kernel message.

## Reproduction and isolation

The following have been tested:

- YouTube playback in Zen: reproduces the issue.
- Browser hardware acceleration disabled: issue still reproduced.
- Video decoding disabled: issue still reproduced on two occasions.
- Ghostty and Alacritty: both reproduced the issue.
- Noctalia stopped: the issue still reproduced; see the no-Noctalia trace below.
- BIOS primary graphics changed from PEG to IGD: issue persisted.
- AMD output over USB-C-to-DP and HDMI: both reproduced it.
- `wait-for-frame-completion-before-queueing`: did not eliminate it.
- EXPO-6000: Memtest86+ completed 2.7 passes with zero errors. EXPO has not yet been disabled as an A/B test.
- Connecting the monitor directly to the NVIDIA GPU: no fence fallback messages observed, but this makes NVIDIA the primary display/render adapter.
- Hyprland on the AMD display path: preliminary test with 10 minutes of continuous YouTube playback produced no fence fallback messages. A longer idle-to-video test is pending.

The clean NVIDIA result and the preliminary Hyprland result make application-specific causes such as Ghostty, Zen, or YouTube less likely. The Hyprland test is not yet long enough to establish that the issue is absent there.

## Relevant Niri GLES errors

At local time `16:14:31.665` (`20:14:31Z`), Niri emitted multiple errors including:

```text
GL_INVALID_VALUE in glTexSubImage2D(xoffset 0 + width 1763 > 919)
GL_INVALID_VALUE in glTexSubImage2D(xoffset 0 + width 1342 > 919)
```

At `16:16:09.842`, it emitted errors including:

```text
GL_INVALID_VALUE in glTexSubImage2D(xoffset 0 + width 1677 > 833)
GL_INVALID_VALUE in glTexSubImage2D(xoffset 0 + width 1763 > 919)
```

These are invalid texture bounds: the requested upload is wider than the allocated texture. They are not exactly simultaneous with every fence fallback, but occur in the same failure-prone session. The closest fallback messages were at `16:14:18`, `16:15:14`, and surrounding times.

## Trace evidence

Tracing was recorded with:

```bash
sudo trace-cmd record -o /tmp/amdgpu-fence-2.dat \
  -e amdgpu:amdgpu_iv \
  -e amdgpu:amdgpu_cs_ioctl \
  -e amdgpu:amdgpu_sched_run_job \
  -e gpu_scheduler:drm_sched_job_run \
  -e gpu_scheduler:drm_sched_job_done \
  -e dma_fence:dma_fence_signaled \
  sleep 120
```

In the attached `no-noctalia-fence.txt` trace, the fallback occurred at monotonic time `3437.978088` (the trace shows `3437.979724`). The relevant sequence was:

```text
3437.476077  niri: amdgpu_cs_ioctl fence=264:173858, timeline=gfx_0.1.0
3437.476089  drm_sched_job_run fence=264:173858, ring=gfx_0.1.0
3437.979724  amdgpu_fence_fallback()
3437.979727  dma_fence_signaled driver=amdgpu timeline=gfx_0.1.0 context=3 seqno=179055
3437.979729  drm_sched_job_done fence=264:173858
```

Thus Niri submitted the scheduler fence on `gfx_0.1.0`; approximately 504 ms later the fallback path processed the underlying AMDGPU fence and completed it. The trace also shows Niri continuing to submit jobs immediately afterward.

A separate Alacritty trace showed the same pattern: Niri submitted the fence on `gfx_0.1.0` immediately before the fallback, while Alacritty submitted work on `gfx_0.0.0` that only ran after the fallback. This suggests the failed/delayed scheduler work belongs to Niri’s compositor path, not directly to the terminal application.

The no-Noctalia trace contained no Noctalia process activity. It did contain Niri, Ghostty, Zen, and a small amount of Alacritty activity. Full traces can be provided if useful.

## Other kernel observations

After suspend/resume, AMDGPU logged:

```text
[drm] lttpr_caps phy_repeater_cnt is 0x0, forcing it to 0x80.
[drm] LTTPR count is nonzero but invalid lane count reported. Assuming no LTTPR present.
```

There are also occasional USB reset timeout messages, but no evidence yet that they are causally related. No GPU reset, ring timeout, VM fault, or PCIe/AER error has been observed alongside the fence fallback.

## Questions

1. Does the `glTexSubImage2D` bounds error indicate a known Niri/Smithay damage or output-scaling bug?
2. Is `gfx_0.1.0` expected to be Niri’s compositor/scanout submission path on this AMDGPU device?
3. Could Niri probing or opening the NVIDIA DRM device be relevant? Niri used approximately 4 MiB of NVIDIA memory according to `nvidia-smi`, while Hyprland currently shows no NVIDIA usage.
4. Would testing Niri with the AMD render node explicitly selected and the NVIDIA DRM device ignored be useful?

The Niri configuration used opacity, rounded corners, clipping, an xray background effect, and shadows. Removing those effects and testing a minimal configuration is the next planned Niri-side A/B test if the Hyprland comparison continues to remain clean.
