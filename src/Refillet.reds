module Refillet.Main

import Refillet.Constants.*


private static func IsNativeAmmo(tdbID: TweakDBID) -> Bool {
    //LogChannel(n"IsNativeAmmo", s"\(TDBID.ToStringDEBUG(tdbID))");
    switch tdbID {
        case HandgunAmmoID():
            return true;
        case RifleAmmoID():
            return true;
        case SniperRifleAmmoID():
            return true;
        case ShotgunAmmoID():
            return true;
        default:
            return false;
    }
}

private static func AmmoLowCondition(ammoMax: Int32, currentAmmoCount: Int32) -> Bool {
    return Cast<Int32>((Cast<Float>(ammoMax) * 0.35)) > currentAmmoCount;
}

private static func IsAmmoLow(tdbID: TweakDBID, currentAmmoCount: Int32) -> Bool {
    switch tdbID {
        case HandgunAmmoID():
            return AmmoLowCondition(HandgunAmmoMax(), currentAmmoCount);
        case RifleAmmoID():
            return AmmoLowCondition(RifleAmmoMax(), currentAmmoCount);
        case SniperRifleAmmoID():
            return AmmoLowCondition(SniperRifleAmmoMax(), currentAmmoCount);
        case ShotgunAmmoID():
            return AmmoLowCondition(ShotgunAmmoMax(), currentAmmoCount);
        default:
            return false;
    }
}

private static func GetRefillAmount(tdbID: TweakDBID, currentAmmoCount: Int32) -> Int32 {
    switch tdbID {
        case HandgunAmmoID():
            return HandgunAmmoMax() - currentAmmoCount;
        case RifleAmmoID():
            return RifleAmmoMax() - currentAmmoCount;
        case SniperRifleAmmoID():
            return SniperRifleAmmoMax() - currentAmmoCount;
        case ShotgunAmmoID():
            return ShotgunAmmoMax() - currentAmmoCount;
    }
}


@wrapMethod(ReloadEvents)
protected func OnEnter(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Void {
    let game: ref<GameObject> = scriptInterface.executionOwner;
    let weapon: ref<WeaponObject> = scriptInterface.owner as WeaponObject;


    let ammoID: TweakDBID = weapon.GetWeaponRecord().Ammo().GetRecordID();
    let currentAmmoCount: Int32 = weapon.GetTotalAmmoCount();

    if IsNativeAmmo(ammoID) && IsAmmoLow(ammoID, currentAmmoCount) {
        GameInstance.GetTransactionSystem(game.GetGame()).GiveItemByTDBID(game, ammoID, GetRefillAmount(ammoID, currentAmmoCount));
    }
    
    wrappedMethod(stateContext, scriptInterface);
}