# Copyright (c) 2021 CRS4
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

"""\
Update package versions.
"""

import argparse
import hashlib
import os
import re
from io import DEFAULT_BUFFER_SIZE
from packaging.version import parse as vparse
from pathlib import Path

import requests
from github import Github


ALL_PACKAGES = "eddl", "pyeddl", "ecvl", "pyecvl"
ALL_BUILD_TYPES = "cpu", "gpu", "cudnn"
REQUIRED_BY = {
    "eddl": ["pyeddl", "ecvl", "pyecvl"],
    "ecvl": ["pyecvl"],
    "pyeddl": ["pyecvl"],
    "pyecvl": []
}
_LATEST_VERSION = {}
_CHECKSUM = {}

def get_current_version(package, build_type="cpu"):
    path = Path(build_type) / package / "meta.yaml"
    with open(path, "rt") as f:
        content = f.read()
    return re.findall(r'set version = "([^"]+)"', content)[0]


def get_latest_version(gh, package):
    try:
        rval = _LATEST_VERSION[package]
    except KeyError:
        print(f"{package}: getting latest version from GitHub")
        repo = gh.get_repo(f"deephealthproject/{package}")
        tags = [_.name for _ in repo.get_tags()]
        rval = _LATEST_VERSION[package] = max([(vparse(_), _) for _ in tags])[1]
    return rval


def get_checksum(package, version):
    try:
        rval = _CHECKSUM[(package, version)]
    except KeyError:
        print(f"{package} {version}: computing checksum")
        url = f"https://github.com/deephealthproject/{package}/archive/{version}.tar.gz"
        h = hashlib.sha256()
        with requests.get(url, stream=True) as r:
            r.raise_for_status()
            for chunk in r.iter_content(chunk_size=DEFAULT_BUFFER_SIZE):
                h.update(chunk)
        rval = _CHECKSUM[(package, version)] = h.hexdigest()
    return rval


def update_meta(path, version, checksum):
    with open(path, "rt") as f:
        content = f.read()
    content = re.sub(r'set version = "([^"]+)"', rf'set version = "{version}"', content)
    content = re.sub(r'sha256 = "([^"]+)"', rf'sha256 = "{checksum}"', content)
    content = re.sub(r'number:\s*\d+', r'number: 0', content)
    with open(path, "wt") as f:
        f.write(content)


def update_meta_deps(path, package, build_type, version):
    if version.lower().startswith("v"):
        version = version[1:]
    name = f"{package}-{build_type}"
    with open(path, "rt") as f:
        content = f.read()
    content = re.sub(rf' {name}\s*==.+$', rf' {name} =={version}', content,
                     flags=re.MULTILINE)
    with open(path, "wt") as f:
        f.write(content)


def main(args):
    token = os.getenv("GITHUB_API_TOKEN")
    gh = Github(token) if token else Github()
    packages = (args.package,) if args.package else ALL_PACKAGES
    build_types = (args.build_type,) if args.build_type else ALL_BUILD_TYPES
    for p in packages:
        for t in build_types:
            current_version = get_current_version(p, t)
            version = args.version or get_latest_version(gh, p)
            if current_version == version:
                print(f"package {p}: already at version {version}")
                continue
            print(f"{p}-{t}: {current_version} => {version}")
            if args.dry_run:
                continue
            checksum = get_checksum(p, version)
            path = Path(t) / p / "meta.yaml"
            print(f"updating {path}")
            update_meta(path, version, checksum)
            for r in REQUIRED_BY[p]:
                rpath = Path(t) / r / "meta.yaml"
                print(f"  updating deps in {rpath}")
                update_meta_deps(rpath, p, t, version)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawTextHelpFormatter
    )
    parser.add_argument("-p", "--package", metavar="|".join(ALL_PACKAGES),
                        choices=ALL_PACKAGES, help="package name")
    parser.add_argument("-t", "--build-type", metavar="|".join(ALL_BUILD_TYPES),
                        choices=ALL_BUILD_TYPES, help="build type")
    parser.add_argument("-v", "--version", metavar="STRING",
                        help="new version string")
    parser.add_argument("-n", "--dry-run", action="store_true",
                        help="show what needs to be done, but don't do it")
    main(parser.parse_args())
