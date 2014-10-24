package dragonBones.utils {

	public function dbToString( obj : Object ) : String {
		return toStringObject( "", "\t", obj );
	}

}

import dragonBones.objects.AnimationData;
import dragonBones.objects.ArmatureData;
import dragonBones.objects.BoneData;
import dragonBones.objects.DisplayData;
import dragonBones.objects.Frame;
import dragonBones.objects.SkeletonData;
import dragonBones.objects.SkinData;
import dragonBones.objects.SlotData;
import dragonBones.objects.TransformTimeline;

function _dbToString( prefix : String, obj : Object, name : String, props : Array, lists : Object, maps : Object ) : String {
	var res : String = name + "\n";
	prefix += "\t";
	for each ( var prop : String in props ) {
		res += prefix + prop + "=" + toStringObject( '', prefix + '\t', obj[ prop ] );
	}
	var tmp : Array = [];
	for ( var listName : String in lists ) {
		tmp.push( listName );
	}
	tmp.sort();
	for each ( listName in tmp ) {
		res += prefix + listName + "\n";
		for each ( var itm : Object in lists[ listName ] ) {
			res += toStringObject( prefix + "\t", prefix + "\t", itm );
		}
	}
	tmp.length = 0;
	for ( var mapName : String in maps ) {
		tmp.push( mapName );
	}
	tmp.sort();
	var tmp2 : Array = [];
	for each ( mapName in tmp ) {
		res += prefix + mapName + "\n";
		tmp2.length = 0;
		for ( var itmName : String in maps[ mapName ] ) {
			tmp2.push( itmName );
		}
		tmp2.sort();
		for each ( itmName in tmp2 ) {
			itm = maps[mapName][itmName];
			res += prefix + "\t" + itmName + "=>" + toStringObject( "", prefix + "\t", itm );
		}
	}
	return res;
}

function toStringObject( prefixOutside : String, prefixInside : String, obj : Object ) : String {
	var str : String;
	if ( obj is ArmatureData ) {
		str = ArmatureData_dbToString( obj as ArmatureData, prefixInside );
	} else if ( obj is AnimationData ) {
		str = AnimationData_dbToString( obj as AnimationData, prefixInside );
	} else if ( obj is BoneData ) {
		str = BoneData_dbToString( obj as BoneData, prefixInside );
	} else if ( obj is DisplayData ) {
		str = DisplayData_dbToString( obj as DisplayData, prefixInside );
	} else if ( obj is SkeletonData ) {
		str = SkeletonData_dbToString( obj as SkeletonData, prefixInside );
	} else if ( obj is SkinData ) {
		str = SkinData_dbToString( obj as SkinData, prefixInside );
	} else if ( obj is SlotData ) {
		str = SlotData_dbToString( obj as SlotData, prefixInside );
	} else if ( obj is TransformTimeline ) {
		str = TransformTimeline_dbToString( obj as TransformTimeline, prefixInside );
	} else if ( obj is Frame ) {
		var f : Frame = obj as Frame;
		str = "Frame pos=" + f.position + " duration=" + f.duration + " action=" + f.action + " event=" + f.event + " sound=" + f.sound;
	} else {
		str = String( obj );
	}
	return prefixOutside + str + "\n";
}


function ArmatureData_dbToString( ad : ArmatureData, toStringPrefix : String = "" ) : String {
	return _dbToString( toStringPrefix, ad, "ArmatureData " + ad.name, [], {
		animationDataList : ad.animationDataList,
		boneDataList : ad.boneDataList,
		skinDataList : ad.skinDataList }, {} );
}

function AnimationData_dbToString( ad : AnimationData, toStringPrefix : String ) : String {
	return _dbToString( toStringPrefix, ad, "AnimationData " + ad.name, [
		"duration",
		"scale",
		"autoTween",
		"fadeTime",
		"frameRate",
		"lastFrameDuration",
		"playTimes",
		"tweenEasing" ], {
		frameList : ad.frameList,
		hideTimelineNameMap : ad.hideTimelineNameMap,
		timelineList : ad.timelineList }, {} );
}


function BoneData_dbToString( bd : BoneData, toStringPrefix : String = "" ) : String {
	return _dbToString( toStringPrefix, bd, "BoneData " + bd.name, [
		"global",
		"inheritRotation",
		"inheritScale",
		"length",
		"level",
		"transform" ], {}, {} );
}

function DisplayData_dbToString( dd : DisplayData, toStringPrefix : String = "" ) : String {
	return _dbToString( toStringPrefix, dd, "DisplayData " + dd.name, [
		"type" ,
		"transform" ,
		"pivot" ], {}, {} );
}

function SkeletonData_dbToString( sd : SkeletonData, toStringPrefix : String = "" ) : String {
	return _dbToString( toStringPrefix, sd, "SkeletonData " + sd.name, [], {
		armatureDataList : sd.armatureDataList }, {
		subTexturePivots : sd.subTexturePivots } );
}

function SkinData_dbToString( sd : SkinData, toStringPrefix : String = "" ) : String {
	return _dbToString( toStringPrefix, sd, "SkinData " + sd.name, [], {
		slotDataList : sd.slotDataList }, {} )
}

function SlotData_dbToString( sd : SlotData, toStringPrefix : String = "" ) : String {
	return _dbToString( toStringPrefix, this, "SlotData " + sd.name, [
		"blendMode",
		"parent",
		"zOrder" ], {
		displayDataList : sd.displayDataList }, {} );
}


function TransformTimeline_dbToString( tt : TransformTimeline, toStringPrefix : String = "" ) : String {
	return _dbToString( toStringPrefix, this, "TransformTimeline " + tt.name, [
		"duration",
		"scale",
		"offset",
		"originPivot",
		"originTransform",
		"transformed" ], {
		frameList : tt.frameList }, {} );
}