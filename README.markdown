# hidepw - an Emacs minor mode for hiding passwords

This is an Emacs minor mode for hiding passwords. It's useful if you
manage your passwords in text files (perhaps automatically encrypted
and decrypted by [EasyPG](https://epg.osdn.jp/index.html.en)) and want to
prevent shoulder surfing.

When enabled, any passwords will appear as ******, but you'll still be
able to copy the password to the clipboard.

By default, passwords are marked by delimiting them with braces ([]).
For example:

```
root: [supersecret]
```

will display as

```
root: [******]
```

You can customize hidepw-patterns to match against arbitrary regular
expressions. Just make sure to include one capturing group (`\(\)`),
since the group marks the actual password. You can also customize the
mask (******) that obscures the password.

You can enable hidepw-mode automatically on `.gpg` files with:

```
(add-to-list 'auto-mode-alist
             '("\\.gpg\\'" . hidepw-mode))
```

## Notes:

You won't be able to move the cursor within the password (it will
behave like a single character), but deleting the delimiter from
either side will reveal the password and make it editable. Just add
the delimiter back to hide it again.

This mode turns on font-lock-mode (and won't turn it off when you turn
 off this mode).
