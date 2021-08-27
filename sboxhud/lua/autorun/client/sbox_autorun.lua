function drawhudikgovno()
    local sboxhud = vgui.Create("DHTML",GetHUDPanel())
    sboxhud:Dock(FILL)
    sboxhud:SetHTML([[
    <style type="text/css">
    .box {
        position: absolute;
        left: 72px;
        top: 85%;
        width: 540px;
        height: 100px;
        background-color: rgba(32, 30, 34, 0.85);
        mix-blend-mode: normal;
        border-radius: 35px;
    }

    .hp {
        position: absolute;
        width: 27px;
        height: 15px;
        left: 189px;
        top: 17px;
        font-family: Proxima Nova;
        font-style: normal;
        font-weight: 300;
        font-size: 12px;
        line-height: 15px;
        color: #FFFFFF;
    }

    .bronya {
        position: absolute;
        width: 27px;
        height: 15px;
        left: 189px;
        top: 47px;
        font-family: Proxima Nova;
        font-style: normal;
        font-weight: 300;
        font-size: 12px;
        line-height: 15px;
        color: #FFFFFF;
    }

    .ammobox {
        position: absolute;
        width: 57px;
        height: 29px;
        left: 444px;
        top: 35px;
        font-family: Proxima Nova;
        font-style: normal;
        font-weight: 300;
        font-size: 24px;
        line-height: 29px;
        color: #FFFFFF;
        white-space: nowrap;
    }

    .job {
        position: absolute;
        width: 124px;
        height: 29px;
        left: 25px;
        top: 36px;
        font-family: Proxima Nova;
        font-style: normal;
        font-weight: 600;
        font-size: 24px;
        white-space: nowrap;
        line-height: 29px;
        color: #FFFFFF;
    }

    img.ammopng {
        position: absolute;
        width: 16px;
        height: 16px;
        left: 426px;
        top: 42px;
    }

    .hpline {
        position: absolute;
        width: 194px;
        height: 7px;
        left: 189px;
        top: 32px;
        background-color: #F52E2E;
        border-radius: 11px;
    }

    .armorline {
        position: absolute;
        width: 194px;
        height: 7px;
        left: 189px;
        top: 61px;
        background-color: #2EBAF5;
        border-radius: 11px;
    }
    </style> 

    <div>
        <meta charset="utf-8">
        <div id = "idbox" class="box">
            <div id = "health" class="hp"></div>
            <div id = "armor" class="bronya"></div>
            <div id = "name" class="job"></div>
            <div id = "ammo" class="ammobox"></div>
            <img id = "weaponpic" class="ammopng" src="https://cdn.discordapp.com/attachments/729138495750406194/880436885443452978/icons8--2-100.png">
            <div id = "healthbar" class="hpline"></div>
            <div id = "armorbar" class="armorline"></div>
        </div>
            <chatbox></chatbox>
    </div>
    ]])
    function sboxhud:Think()
        local ply = LocalPlayer()
        self:RunJavascript([[document.getElementById("healthbar").style["width"] = "]] .. tostring(194 * (ply:Health()/ply:GetMaxHealth())) .. [[px";]])
        self:RunJavascript([[document.getElementById("armorbar").style["width"] = "]] .. tostring(194 * (ply:Armor()/ply:GetMaxArmor())) .. [[px";]])
        self:RunJavascript([[document.getElementById("health").innerHTML = "]] .. tostring(ply:Health()) .. [[%";]])
        if ply:Health() <= 0 then
            self:RunJavascript([[document.getElementById("idbox").style.display = 'none';]])
        else
            self:RunJavascript([[document.getElementById("idbox").style.display = 'block';]])
        end
        if ply:Armor() <= 0 then
            self:RunJavascript([[document.getElementById("armor").innerHTML = "";]])
        else
            self:RunJavascript([[document.getElementById("armor").innerHTML = "]] .. tostring(ply:Armor()) .. [[%";]])
        end
        self:RunJavascript([[document.getElementById("name").innerHTML = "]] .. tostring(ply:Nick()) .. [[";]])
        local weap = ply:GetActiveWeapon()
        local zalupa = {
            weapon_rpg = true,
            weapon_frag = true
        }
        local eblan = { weapon_slam = true }
        local suka = { weapon_physcannon = true }
        if IsValid(weap) then
            if weap:Clip1() != -1 and !eblan[weap:GetClass()] and !suka[weap:GetClass()] then
                self:RunJavascript([[document.getElementById("weaponpic").style.display = 'block';]])
                self:RunJavascript([[document.getElementById("ammo").innerHTML = "| ]] .. tostring(weap:Clip1()) .. [[/]]..tostring(ply:GetAmmoCount( weap:GetPrimaryAmmoType() ))..[[";]])
            elseif zalupa[weap:GetClass()] then
                self:RunJavascript([[document.getElementById("weaponpic").style.display = 'block';]])
                self:RunJavascript([[document.getElementById("ammo").innerHTML = "| ]] .. tostring(ply:GetAmmoCount( weap:GetPrimaryAmmoType()))..[[";]])
            elseif eblan[weap:GetClass()] then
                self:RunJavascript([[document.getElementById("weaponpic").style.display = 'block';]])
                self:RunJavascript([[document.getElementById("ammo").innerHTML = "| ]] .. tostring(ply:GetAmmoCount( weap:GetSecondaryAmmoType()))..[[";]])
            else
                self:RunJavascript([[document.getElementById("weaponpic").style.display = 'none';]])
                self:RunJavascript([[document.getElementById("ammo").innerHTML = "";]])
            end
        end
    end
end
local disable = {
    ['CHudHealth'] =true,
    ['CHudBattery'] =true,
    ['CHudSuitPower'] =true,
    ['CHudAmmo'] =true,
    ['CHudSecondaryAmmo'] =true,
    ['DarkRP_LocalPlayerHUD'] =true,
    ['DarkRP_Hungermod'] =true,
    ['DarkRP_LockdownHUD'] =true,
    ['CHudVoiceSelfStatus'] =true,
    ['CHudVoiceStatus'] =true,
}
hook.Add( "HUDShouldDraw", "HideHUD", function( name )
  if disable[name] then
  return false
end
end)

hook.Add("HUDPaint","DrawHudik",function()
    drawhudikgovno()
    hook.Remove("HUDPaint","DrawHudik")
end)