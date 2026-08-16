#!/usr/bin/python3

import gi
gi.require_version('Goa', '1.0')
from gi.repository import Goa

if __name__ == '__main__':
    client = Goa.Client.new_sync(None)

    for item in client.get_accounts():
        account = item.get_account()
        print(
            '{} at {} ({})'.format(
                account.props.presentation_identity,
                account.props.provider_name,
                account.props.provider_type,
            )
        )
