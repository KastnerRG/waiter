'''Ansible Deploy Service
'''
import argparse
import datetime as dt
import logging
import os
import subprocess
from pathlib import Path
from time import sleep

from git import Repo
from prometheus_client import start_http_server

import docker


class Service:
    def __init__(self, period: int, prometheus_port: int, project_root: Path, project_branch: str):
        self.PERIOD = dt.timedelta(seconds=period)
        self.PROM_PORT = prometheus_port

        self.last_run = dt.datetime.now()
        self.PROJECT_ROOT = project_root
        self.repo = Repo(self.PROJECT_ROOT)
        self.PROJECT_BRANCH = {
            head.name: head for head in self.repo.heads}[project_branch]
        self.__log = logging.getLogger('Waiter Ansible Deploy')

    def run(self):
        start_http_server(self.PROM_PORT)
        self.last_run = None

        while True:
            if self.last_run:
                next_run = self.last_run + self.PERIOD
                self.sleep_until(next_run)

            self.PROJECT_BRANCH.checkout(True)
            self.repo.remote().update()

            origin_diff = self.PROJECT_BRANCH.commit.diff(
                self.repo.remote().repo.head.commit)
            if len(origin_diff) != 0:
                # Install
                self.repo.remote().pull()
                subprocess.check_call(['ansible-galaxy', 'collection', 'install',
                            '-r', 'requirements.yml'])
                new_env = os.environ
                new_env['ANSIBLE_CONFIG'] = self.PROJECT_ROOT.joinpath(
                    'ansible.cfg').absolute().as_posix()
                new_env['ANSIBLE_INVENTORY'] = self.PROJECT_ROOT.joinpath(
                    'inventory.yaml').absolute().as_posix()
                bw_session_path = self.PROJECT_ROOT.joinpath('.bw_session')
                with open(bw_session_path, 'r', encoding='utf-8') as handle:
                    bw_session = handle.read()
                new_env['BW_SESSION'] = bw_session
                subprocess.check_call([
                    'ansible-playbook',
                    'playbook.yaml'
                ], env=new_env)
                docker_client = docker.from_env()
                docker_client.images.prune()

            self.last_run = dt.datetime.now()

    def sleep_until(self, until: dt.datetime):
        """Sleeps until the specified datetime

        Args:
            until (dt.datetime): Datetime to sleep until
        """
        now = dt.datetime.now()
        delta = (until - now).total_seconds()
        if delta < 0:
            return
        sleep(delta)


def main():
    """Main entry point
    """
    parser = argparse.ArgumentParser()
    parser.add_argument('--period', type=int,
                        help='Seconds between runs', default=60)
    parser.add_argument('--prometheus_port', type=int,
                        help='Prometheus port', default=9000)
    parser.add_argument('--project_root', type=Path,
                        help='Ansible project root', default=Path('.'))
    parser.add_argument('--project_branch', type=str,
                        help='Project branch', default='main')
    args = parser.parse_args()

    Service(args.period, args.prometheus_port,
            args.project_root, args.project_branch).run()


if __name__ == '__main__':
    main()
