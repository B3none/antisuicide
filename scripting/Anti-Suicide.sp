#include <sourcemod> 
#include <cstrike> 

#define TAG_MESSAGE "[\x0CAnti-Suicide\x01]"
bool canAnnounce[MAXPLAYERS + 1];

public Plugin myinfo = 
{ 
    name = "Anti-Suicide Plugin", 
    author = "B3none", 
    description = "Please don't suicide! :/", 
    version = "1.1.0", 
    url = "https://github.com/b3none" 
}; 

public void OnPluginStart() 
{ 
    AddCommandListener(Suicide, "kill"); 
    AddCommandListener(Suicide, "explode");
    HookEvent("player_disconnect", OnPlayerDisconnect);
} 

public Action Suicide(int client, const char[] command, int args) 
{
	for(int i = 1; i <= MaxClients; i++) {
		if(canAnnounce[client]) {
			char name[32];
			GetClientName(client, name, sizeof(name));
			
			PrintToChatAll("%s %s just attempted suicide, show them some love!", TAG_MESSAGE, name);
			canAnnounce[client] = false;
			CreateTimer(60.0, ResetAnnouncmentState);
		}
	}
	return Plugin_Handled;
}

public void OnMapStart()
{
	for(int i = 1; i <= MAXPLAYERS+1; i++) {
		canAnnounce[i] = true;
	}
}

public Action ResetAnnouncmentState(Handle timer, int client)
{
	canAnnounce[client] = true;
}

public Action OnPlayerDisconnect(Handle event, const char []name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	canAnnounce[client] = true;
}
