#include <sourcemod> 
#include <cstrike> 

#define TAG_MESSAGE "[\x0CAnti-Suicide\x01]"
bool b_CanAnnounce[MAXPLAYERS+1];

public Plugin myinfo = 
{ 
    name = "Anti-Suicide Plugin", 
    author = "Nevvy Edits by B3none", 
    description = "Please don't suicide! :/", 
    version = "1.0", 
    url = "www.voidrealitygaming.co.uk" 
}; 

public void OnPluginStart() 
{ 
    AddCommandListener(Suicide, "kill"); 
    AddCommandListener(Suicide, "explode");
    CreateTimer(60.0, Kill_Announce,_, TIMER_REPEAT);
} 

public Action Suicide(int client, const char[] command, int args) 
{
	char name[32];
	GetClientName(client, name, sizeof(name));
	
	for(int i = 1; i <= MAXPLAYERS+1; i++)
	{
		if(b_CanAnnounce[client])
		{
			if(i == client)
			{
				PrintToChat(i, "%s We all love you %s, your life must have some value!", TAG_MESSAGE, name);
				b_CanAnnounce[i] = false;
			}
			/* I am well aware that this is flawed logic lmao
			* Explanation of flaw for future reference:
			*  Client types "kill" (prints to others && himself)
			*  Another client types kill (prints to others who have b_CanAnnounce true...)
			*  Not the initial client who typed kill because his is false for 60 seconds.
			*/
			
			else
			{
				PrintToChat(i, "%s %s just attempted suicide, show them some love!", TAG_MESSAGE, name);
			}
		}
	}
	return Plugin_Handled;
}

public void OnMapStart()
{
	for(int i = 1; i <= MAXPLAYERS+1; i++)
	{
		b_CanAnnounce[i] = true;
	}
}

public void OnMapEnd()
{
	for(int i = 1; i <= MAXPLAYERS+1; i++)
	{
		b_CanAnnounce[i] = true;
	}
}

public Action Kill_Announce(Handle timer, int client)
{
	b_CanAnnounce[client] = true;
}
