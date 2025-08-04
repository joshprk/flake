from typing import Any, Callable, Optional
import tempfile
import textwrap
import json
import subprocess

from git import Repo
from rich.console import Console
from rich.progress import Progress
from rich.prompt import Confirm, Prompt
import requests

class DeployApp:
    def __init__(self) -> None:
        self.console = Console()

    def _info(self) -> None:
        self.console.print("[bold blue]deployment tool[/bold blue]")

    def _error(self, msg: str) -> None:
        self.console.print(f"[red]error: {msg}[/red]")

    def _prompt(
        self,
        prompt: str,
        default: Optional[str] = None,
        password: bool = False,
        validate: Optional[Callable[str, bool]] = None,
        invalid_msg: Optional[str] = None,
        apply: Optional[Callable[str, Any]] = None,
    ) -> str:
        while True:
            res = Prompt.ask(
                prompt,
                default=default,
                password=password
            )

            if res is None:
                self._error("this field is required")
                continue

            res = res.strip()

            if validate is not None and not validate(res):
                msg = "invalid input" if invalid_msg is None else invalid_msg
                self._error(msg)
                continue

            if apply is not None:
                while True:
                    try:
                        res = apply(res)
                        break
                    except Exception as e:
                        self._error(f"apply failed")
                        self.console.print(e)

            return res

    def _transform_flake_url(self, res: str) -> str:
        provider, repo = res.lower().split(":")

        if provider == "github":
            return f"https://github.com/{repo}"
        elif provider == "git+https":
            return f"https:{repo}"
        else:
            raise NotImplementedError(f"provider '{provider}' not implemented")

    def _validate_hostname(self, hostname: str) -> str:
        return True

    def run(self) -> None:
        self._info()

        self._flake_url = self._prompt(
            "flake url",
            default="github:joshprk/flake",
            validate=lambda s: ":" in s,
            apply=self._transform_flake_url,
        )

        with Progress(transient=True) as progress:
            progress.add_task(description="cloning flake repo", start=False)
            self._temp_dir = tempfile.TemporaryDirectory()
            self._repo = Repo.clone_from(self._flake_url, self._temp_dir.name)

        self._nixeval = json.loads(
            subprocess.run(
                ["nix", "flake", "show", "--json", self._temp_dir.name],
                capture_output=True,
                text=True,
                check=True
            ).stdout
        )

        self._hostname = self._prompt(
            "hostname",
            validate=lambda x: x in self._nixeval.get("nixosConfigurations"),
            invalid_msg="host does not exist in flake",
        )

def main() -> None:
    app = DeployApp()
    app.run()

if __name__ == "__main__":
    main()
