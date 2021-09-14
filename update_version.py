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
from pathlib import Path

import requests
from dateutil.parser import isoparse
from github import Github


ALL_PACKAGES = "eddl", "pyeddl", "ecvl", "pyecvl"


def get_current_version(package):
    path = Path("cpu") / package / "meta.yaml"
    with open(path, "rt") as f:
        content = f.read()
    return re.findall(r'set version = "([^"]+)"', content)[0]


def _tag_date(tag):
    return isoparse(tag.commit.raw_data["commit"]["committer"]["date"])


def get_latest_version(gh, package):
    repo = gh.get_repo(f"deephealthproject/{package}")
    tags = repo.get_tags()
    return max(tags, key=_tag_date).name


def get_checksum(package, version):
    url = f"https://github.com/deephealthproject/{package}/archive/{version}.tar.gz"
    h = hashlib.sha256()
    with requests.get(url, stream=True) as r:
        r.raise_for_status()
        for chunk in r.iter_content(chunk_size=DEFAULT_BUFFER_SIZE):
            h.update(chunk)
    return h.hexdigest()


def update_meta(path, version, checksum):
    with open(path, "rt") as f:
        content = f.read()
    content = re.sub(r'set version = "([^"]+)"', rf'set version = "{version}"', content)
    content = re.sub(r'sha256 = "([^"]+)"', rf'sha256 = "{checksum}"', content)
    with open(path, "wt") as f:
        f.write(content)


def main(args):
    token = os.getenv("GITHUB_API_TOKEN")
    gh = Github(token) if token else Github()
    packages = (args.package,) if args.package else ALL_PACKAGES
    for p in packages:
        current_version = get_current_version(p)
        if not args.version:
            print(f"getting latest version for {p}... ", end="", flush=True)
            args.version = get_latest_version(gh, p)
            print(args.version)
        if current_version == args.version:
            print(f"package {p}: already at version {args.version}")
            continue
        print(f"package {p}: {current_version} => {args.version}")
        if args.dry_run:
            continue
        checksum = get_checksum(p, args.version)
        for t in "cpu", "cudnn", "gpu":
            path = Path(t) / p / "meta.yaml"
            print(f"  updating {path}")
            update_meta(path, args.version, checksum)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawTextHelpFormatter
    )
    parser.add_argument("-p", "--package", metavar="|".join(ALL_PACKAGES),
                        choices=ALL_PACKAGES, help="package name")
    parser.add_argument("-v", "--version", metavar="STRING",
                        help="new version string")
    parser.add_argument("-n", "--dry-run", action="store_true",
                        help="show what needs to be done, but don't do it")
    main(parser.parse_args())
