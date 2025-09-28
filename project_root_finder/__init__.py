from pathlib import Path
from typing import Optional, Union

def _get_project_root(start_path: Optional[Union[str, Path]] = None, marker_filename: str = ".project-root-hook") -> Optional[Path]:
    if start_path is None:
        path = Path.cwd()
    else:
        path = Path(start_path).resolve()

    fallback_markers = [
        '.git',         # Git repository
        'Pipfile',      # Pipenv projects
        'pyproject.toml', # Poetry or modern Python projects
        'requirements.txt', # Traditional virtualenv-based projects
    ]

    for parent in [path] + list(path.parents):
        # First priority: .project-root-hook
        if (parent / marker_filename).is_file():
            return parent

    # If we get here, no .project-root-hook was found
    for parent in [path] + list(path.parents):
        if any((parent / marker).exists() for marker in fallback_markers):
            return parent

    return None

root: Optional[Path] = _get_project_root()

__all__ = ["root"]