#include <a_samp>
#include <sscanf>
#include <zcmd>

// > Macro y color
#define Mensaje SendClientMessage
#define COLOR_INFO 0x31B100FF

// > Diálogos
#define D_MENU_UNO 19 // -> Número unico.
#define D_SUGE 20 // -> Número unico.
#define D_BUGREP 21 // -> Número unico.

public OnGameModeInit()
{
	new File:openedfile = fopen("feedback.txt", io_write);  
    fclose(openedfile);
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{

	if(dialogid == D_MENU_UNO) 
    {
        if(response)
        {
            if(listitem == 0)
            {
                ShowPlayerDialog(playerid, D_SUGE, DIALOG_STYLE_INPUT, "> Sugerencia", "# Explica tu sugerencia en el campo inferior:", ">", "X");
                return 1;
            }
            if(listitem == 1)
            {
                ShowPlayerDialog(playerid, D_BUGREP, DIALOG_STYLE_INPUT, "> Reportar bug", "# Explica el bug en el campo inferior.\n# Rogamos que seas explícito.", ">", "X");
                return 1;
            }
        }
    }
    if(dialogid == D_SUGE)
    {
        if(response)
        {
            Mensaje(playerid, COLOR_INFO, "SERVER:{ffffff} tu sugerencia fue enviada. Será evaluada por un desarrollador lo antes posible.");
            
            new name[MAX_PLAYER_NAME], str[280];
            GetPlayerName(playerid, name, sizeof(name));

            new aviso[256]; // > Usamos 256 celdas para el aviso.
            format(aviso, COLOR_INFO, "ADM:{ffffff} %s envió una sugerencia.", name);
            MensajeAdmin(aviso);
                
            new File:openedfile = fopen("feedback.txt", io_append);
                
            fwrite(openedfile, "----------------------------------------------\r\n");
            fwrite(openedfile, "Sugerencia:\r\n\r\n");
            format(str, sizeof(str), "Nick: %s\r\n", name);
            fwrite(openedfile, str);
            format(str, sizeof(str), "Sugerencia: %s\r\n\r\n", inputtext);
            fwrite(openedfile, str);
            fwrite(openedfile, "----------------------------------------------\r\n");
            fclose(openedfile);
            
            return 1;
        }
    }
    if(dialogid == D_BUGREP)
    {
        if(response)
        {
            SendClientMessage(playerid, COLOR_INFO, "SERVER:{ffffff} tu reporte fue enviado. Será evaluado por un desarrollador.");
            
            new name[MAX_PLAYER_NAME], str[280];
            GetPlayerName(playerid, name, sizeof(name));

            new aviso[256]; // > Usamos 256 celdas para el aviso.
            format(aviso, COLOR_INFO, "ADM:{ffffff} %s informa un bug: %s", name, inputtext);
            MensajeAdmin(aviso);
                
            new File:openedfile = fopen("feedback.txt", io_append);
                
            fwrite(openedfile, "----------------------------------------------\r\n");
            fwrite(openedfile, "BUG REPORT\r\n\r\n");
            format(str, sizeof(str), "Nick: %s\r\n", name);
            fwrite(openedfile, str);
            format(str, sizeof(str), "%s\r\n\r\n", inputtext);
            fwrite(openedfile, str);
            fwrite(openedfile, "----------------------------------------------\r\n");
            fclose(openedfile);
            
            return 1;
                
        }
    }

	return 1;
}

// -> Comandos | zcmd
CMD:limpiarfeedback(playerid, params[])
{
    if(/* Variable de adminisitrador.*/)
    {
        new confirmar[10];
        if(sscanf(params, "%s", confirmar)) return Mensaje(playerid, COLOR_INFO, "CMD: {ffffff} ¿estás seguro de limpiar 'feedback.txt'?, usa /limpiarfeedback confirmar.");
        
        new File:openedfile = fopen("feedback.txt", io_write);
        new str[280];
        new name[MAX_PLAYER_NAME];
        
        GetPlayerName(playerid, name, sizeof(name));
        
        format(str, sizeof(str), "-> Limpiado por %s\r\n", name);
        fwrite(openedfile, str);
    
        fclose(openedfile);
        
        Mensaje(playerid, -1, "> Feedback limpiado."); 
                
        return 1;
    }
    else return Mensaje(playerid, COLOR_INFO, "> No tienes acceso.");
}
CMD:feedback(playerid, params[])
{
    Mensaje(playerid, COLOR_INFO, ">{ffffff} este comando es unicamente para enviar feedback sobre sugerencias y reportes. Cualquier otra cosa acuda a foro.");
    ShowPlayerDialog(playerid, D_MENU_UNO, DIALOG_STYLE_LIST, "> Feedback", ">\tSugerencia\n>\tReportar bug", ">", "X");
    return 1;
}

// -> Stock MensajeAdmin (opcional)
stock MensajeAdmin(string[], color = 1) { //chat de admins
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i)) {
            if(/*Variable de administrador, ejemplo: "pInfo[i][pAdmin] >= 1"*/) {
                if(color == 1) Mensaje(i, 0xE00000FF, string);
                else if(color == 2) Mensaje(i, 0xFFFF00FF, string);
            }
        }
    }
}