package jitv.scenes;

import flash.geom.Point;
import extendedhxpunk.ext.EXTScene;
import extendedhxpunk.ext.EXTOffsetType;
import extendedhxpunk.ext.EXTUtility;
import jitv.ui.JVExampleMenuButton;

/**
 * JVLevelSelectWorld
 * A world in which the player can create ship specs, upgrade ship parts, and visit different levels.
 * Created by Fletcher 11/3/13, Ported by Fletcher 12/15/13
 */
class JVLevelSelectScene extends EXTScene
{
	public function new() 
	{
		super();
	}
	
	override public function begin():Void
	{
		var startLevelButton:JVExampleMenuButton = new JVExampleMenuButton(new Point(0, -10), "start level", buttonCallback, [START_LEVEL_NAME]);
		startLevelButton.offsetAlignmentForSelf = EXTOffsetType.BOTTOM_CENTER;
		var goBackButton:JVExampleMenuButton = new JVExampleMenuButton(new Point(0, 10), "go back", buttonCallback, [BACK_BUTTON_NAME]);
		goBackButton.offsetAlignmentForSelf = EXTOffsetType.TOP_CENTER;
		
		this.staticUiController.rootView.addSubview(startLevelButton);
		this.staticUiController.rootView.addSubview(goBackButton);
	}
	
	public function buttonCallback(args:Array<Dynamic>):Void
	{
		var buttonName:String = args[0];
		//if (buttonName == START_LEVEL_NAME)
			//JVWorldManager.sharedInstance.goToWorldForCombatLevel(new JVLevel());
		//else 
		if (buttonName == BACK_BUTTON_NAME)
			JVSceneManager.sharedInstance().goToMainMenuScene();
	}
	
	/**
	 * Private
	 */
	private static inline var START_LEVEL_NAME:String = "start_level";
	private static inline var BACK_BUTTON_NAME:String = "back_button";
}
