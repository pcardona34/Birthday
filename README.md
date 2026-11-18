# Birthday

AGNoStep Apps
(c) 2026 - Patrick Cardona

Thanks for the GNUstep Developers Community.
This is Free and Open Source software.
Read [LICENSE](./LICENSE) in the root directory.

## What is Birthday?

This is a Family Events Reminder.

From the menu, you can look for events on the current month,  
on the next month or on today.

If some events are available today, a badge will be displayed with the events count.

## Dependencies

**Birthday** depends on:
- A complete GNUstep System:  
see [Agnostep Desktop](https://github.com/pcardona34/agnostep-desktop).
- Lib Renaissance;
- Birthday own tools and scripts.

## Install

You must have superuser privileges to type your password
when asked.

### Install with AGNoStep Apps Manager (recommended)

Run [AGNoStep Apps Manager](../../../agnostep-apps-manager), then:
1. Select category: *agnostep-applications*
2. Select application: *Birthday*
3. Read about info.
4. Confirm installation.

### Install by yourself

- Create a `PRIVATE` folder in your Home `Documents` folder.
- Copy the sample with the name `Birthdays` in this `PRIVATE` folder.
- In the `Scripts` folder, change mode of each scriptwith `chmod +x` command.
- With `sudo`, copy all the scripts from`Scripts` to `/usr/local/bin`
- Build, then install with `sudo` the `Birthday.app`.

## Using

```console
openapp Birthday
```

Or run it from the `Applications` folder.

## Help

It is provided from the `Info/Help...` menu item. You will namely find how to set the  
Birthday data file to feet your needs.
