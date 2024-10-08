'''Interactive utility to add users
'''
import datetime as dt
import secrets
from argparse import ArgumentParser
from pathlib import Path

from passlib.hash import sha512_crypt


def main():
    parser = ArgumentParser()
    parser.add_argument('--user_file',
                        type=Path,
                        default=Path('./waiter_users.yaml'))

    args = parser.parse_args()
    first_name = input('First Name: ')
    last_name = input('Last Name: ')
    email_address = input('Email: ')
    class_flag = (input('Class [y/N]: ').lower() == 'y')
    if class_flag:
        class_code = input('Class code (i.e. cse237c): ').lower()
        term = input('Class term (i.e. FA24): ').lower()
    expiration = None
    while not expiration:
        try:
            expiration_day = dt.date.fromisoformat(input('Expiration: '))
            expiration = dt.datetime.combine(expiration_day, dt.time(23, 59, 59))
        except Exception:
            continue
    ssh_keys = []
    while True:
        new_key = input('SSH Key (enter to escape): ')
        if new_key == '':
            break
        ssh_keys.append(new_key)
    groups = set()
    accepted_groups = {
        1: 'docker',
        2: 'cuda',
        3: 'rdp_users'
    }
    for gid, gname in accepted_groups.items():
        print(f'{gid}: {gname}')
    while True:
        new_group = input('Groups to add (enter to escape): ')
        if new_group == '':
            break
        groups.add(accepted_groups[int(new_group)])
    new_password = secrets.token_urlsafe(25)[:32]

    password_hash = sha512_crypt.hash(new_password)
    if class_flag:
        username = f'{class_code}_{term}_{first_name[0].lower()}_{last_name.split()[-1].lower()}_{hash(email_address) % 999}'
    else:
        username = f'{first_name[0].lower()}.{last_name.split()[-1].lower()}.{hash(email_address) % 999}'
    document =  f'  - username: {username}\n'
    document += f'    name: {first_name} {last_name}\n'
    document += '    authorized_keys:\n'
    for key in ssh_keys:
        document += f'      - {key}\n'
    document += f'    expires: "{expiration.strftime("%Y-%m-%d %H:%M:%S")}"\n'
    document += '    groups:\n'
    for group in groups:
        document += f'      - {group}\n'
    document += f'    password: {password_hash}\n'
    with open(args.user_file, 'a', encoding='utf-8') as handle:
        handle.write(document)

    message =  f'username: {username}@waiter.ucsd.edu\n'
    message += '\n'
    message += f'password: {new_password}\n'
    message += '\n'
    message += 'Please allow up to 24 hours for this account to propagate'
    print(message)

if __name__ == '__main__':
    main()