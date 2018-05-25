# GuildRaidInvite
Simple addon for Vanilla World of Warcraft that lets you auto-invite your guild members to raid

## Usage
Slash command `/graid %triggerphrase%`.

`/graid` - will stop any running auto-invites, if no process is running - will notify that you have to specify phrase to start auto-invites.

`/graid +raid` - will start automatically inviting people who type `+raid` in guild chat or in whisper, if command executed second time - it will stop inviting.

Addon will automaticaly converty party to raid, check if whispering player is in your guild, stop auto-invites when raid is full.

Auto-invites will work only for one `%triggerphrase%`, so if you execute `/graid +raid` and follow it with `/graid +` right after - it will only accept `+` from now one.
