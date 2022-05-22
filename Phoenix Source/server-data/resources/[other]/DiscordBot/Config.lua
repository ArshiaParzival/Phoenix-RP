SystemAvatar = 'https://media.discordapp.net/attachments/787580597177548800/948180206030569472/f0f9fc8d87bfa48e6f280ebe9f86a5e6.png?width=663&height=663'

UserAvatar = 'https://media.discordapp.net/attachments/787580597177548800/948180206030569472/f0f9fc8d87bfa48e6f280ebe9f86a5e6.png?width=663&height=663'

SystemName = 'Phoenix'


-- These special commands will be printed differently in discord, depending on what you set it to
SpecialCommands = {
				   {'/ooc', '**[OOC]:**'},
				   {'/911', '**[911]: (CALLER ID: [ USERNAME_NEEDED_HERE | USERID_NEEDED_HERE ])**'},
				  }

						
-- These blacklisted commands will not be printed in discord
BlacklistedCommands = {
					   '/AnyCommand',
					   '/AnyCommand2',
					  }

-- These Commands will use their own webhook
OwnWebhookCommands = {
					  {'/AnotherCommand', 'WEBHOOK_LINK_HERE'},
					  {'/AnotherCommand2', 'WEBHOOK_LINK_HERE'},
					 }

-- These Commands will be sent as TTS messages
TTSCommands = {
			   '/Whatever',
			   '/Whatever2',
			  }

