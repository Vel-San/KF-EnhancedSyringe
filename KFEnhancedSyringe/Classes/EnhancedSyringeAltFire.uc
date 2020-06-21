//=============================================================================
// EnhancedSyringeAltFire
// Everything written in this class is edited and should be different than the
// original values
// Self Healing Fire
//=============================================================================

class EnhancedSyringeAltFire extends SyringeAltFire Config(KFEnhancedSyringe);

var() config int boostWhen;
var() config int boost;
var() config int boostFor;

var int current_time_seconds;
var int end_boost_at_seconds;

Function Timer()
{
	local float HealSum;

	HealSum = Syringe(Weapon).HealBoostAmount;

	if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != none && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != none )
	{
		HealSum *= KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.Static.GetHealPotency(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo));
	}

    Weapon.ConsumeAmmo(ThisModeNum, AmmoPerFire);
	Instigator.GiveHealth(HealSum, 100);

	/////////////// Vel ///////////////
	end_boost_at_seconds = Level.TimeSeconds + boostFor;
	current_time_seconds = end_boost_at_seconds - boostFor;
	Log("Current Time Seconds: " $current_time_seconds);
	Log("Boost should end at: " $end_boost_at_seconds);
	if(Instigator.Health <= boostWhen)
	{
		if( PlayerController(Instigator.Controller) != none )
    	{
			PlayerController(Instigator.controller).ClientMessage("You gained ~ +" $boost$ " ~ sprint boost for: " $boostFor$ " seconds, now RUN!", 'CriticalEvent');
		}
		Log("Ground Speed before boost: " $Instigator.Groundspeed);
		Log("Default Ground Speed before boost: " $Instigator.default.Groundspeed);
		Instigator.default.Groundspeed = boost;
		default.end_boost_at_seconds = end_boost_at_seconds;
		Log("Ground Speed after boost: " $Instigator.Groundspeed);
		Log("Default Ground Speed after boost: " $Instigator.default.Groundspeed);
	}
}

defaultproperties{
	// If HP less than
	boostWhen=50
	// Boost Power
	boost=300
	// Boost Duration, seconds
	boostFor=2
	// end_boost_at_seconds
	end_boost_at_seconds=0
}