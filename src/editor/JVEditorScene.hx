package editor;

import flash.geom.Point;
import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import extendedhxpunk.ext.EXTScene;
import jitv.datamodel.staticdata.JVEnemyPattern;
import jitv.JVConstants;
import editor.ui.JVEditorMainView;

class JVEditorScene extends EXTScene
{
	public function new()
	{
		HXP.resizeStage(JVEditorConstants.EDITOR_SCREEN_WIDTH , JVEditorConstants.EDITOR_SCREEN_HEIGHT);
		super();
	}

	override public function begin():Void
	{
		super.begin();
		
		_grid = new Array();
		_keyFrameLocationEntities = new Array();
		_dataHandler = new JVEditorDataHandler("./jsondata/" + JVEnemyPattern.DATA_TYPE_NAME + ".json");
		_dataHandler.loadPatternDataFromDisk();
		this.staticUiController.rootView.addSubview(new JVEditorMainView(_dataHandler, loadPatternForDisplay, toggleGridVisibility));

		this.loadPatternForDisplay(0);
	}

	override public function update():Void
	{
		super.update();
	}

	override public function render():Void
	{
		super.render();
		var gfx = HXP.scene.getSpriteByLayer(9999).graphics;
		gfx.beginFill(0x700000, 1.0);
		gfx.drawRect(JVEditorConstants.EDITOR_PREVIEW_SPACE_OFFSET_X, JVEditorConstants.EDITOR_PREVIEW_SPACE_OFFSET_Y, JVConstants.PLAY_SPACE_WIDTH, JVConstants.PLAY_SPACE_HEIGHT);
	}
	
	public function toggleGridVisibility(visible:Bool):Void
	{
		for (i in 0..._grid.length)
		{
			_grid[i].visible = visible;
		}
	}
	
	public function loadPatternForDisplay(patternIndex:Int):Void
	{
		_currentPatternIndex = patternIndex;
		var pattern:JVEnemyPattern = _dataHandler.patterns[_currentPatternIndex];
		
		// Clean up display data from previous pattern
		for (i in 0..._grid.length)
		{
			this.remove(_grid[i]);
		}
		for (i in 0..._keyFrameLocationEntities.length)
		{
			this.remove(_keyFrameLocationEntities[i]);
		}
		_grid.splice(0, _grid.length);
		_keyFrameLocationEntities.splice(0, _keyFrameLocationEntities.length);
		
		// Gather data for this pattern
		var columns:Int = pattern.gridColumns;
		var rows:Int = pattern.gridRows;
		var gridSpaceImage:Image = new Image("gfx/editor/editor_grid_space.png");
		gridSpaceImage.scaledWidth = pattern.totalWidth / columns;
		gridSpaceImage.scaledHeight = pattern.totalHeight / rows;
		var initialX:Int = cast (JVEditorConstants.EDITOR_PREVIEW_SPACE_OFFSET_X + (JVConstants.PLAY_SPACE_WIDTH / 2) - (pattern.totalWidth / 2));
		var initialY:Int = cast (JVEditorConstants.EDITOR_PREVIEW_SPACE_OFFSET_Y + (JVConstants.PLAY_SPACE_HEIGHT / 2) - (pattern.totalHeight / 2));
		
		// Setup the grid
		for (x in 0...columns)
		{
			for (y in 0...rows)
			{
				var entity:Entity = new Entity(initialX + x * gridSpaceImage.scaledWidth, 
											   initialY + y * gridSpaceImage.scaledHeight, 
											   gridSpaceImage);
				this.add(entity);
				_grid.push(entity);
			}
		}
		
		// Setup the keyframe location images
		var shipLocationImage:Image = new Image("gfx/editor/editor_key_frame_location.png");
		if (gridSpaceImage.scaledWidth < gridSpaceImage.scaledHeight)
		{
			shipLocationImage.scaledWidth = gridSpaceImage.scaledWidth - 4;
			shipLocationImage.scaledHeight = gridSpaceImage.scaledWidth - 4;
		}
		else
		{
			shipLocationImage.scaledWidth = gridSpaceImage.scaledHeight - 4;
			shipLocationImage.scaledHeight = gridSpaceImage.scaledHeight - 4;
		}
		shipLocationImage.centerOrigin();
		
		for (i in 0...pattern.keyFramePositions.length)
		{
			var keyframesForShip:Array<Point> = pattern.keyFramePositions[i];
			
			for (j in 0...keyframesForShip.length)
			{
				var keyframe:Point = keyframesForShip[j];
				var gridSpaceEntity:Entity = this.gridSpaceEntityForLocation(cast keyframe.x, cast keyframe.y);
				var keyFrameLocationEntity:Entity = new Entity(gridSpaceEntity.x + (gridSpaceImage.scaledWidth / 2), 
															   gridSpaceEntity.y + (gridSpaceImage.scaledHeight / 2), 
															   shipLocationImage);
				keyFrameLocationEntity.type = "key_frame_location";
				this.add(keyFrameLocationEntity);
				_keyFrameLocationEntities.push(keyFrameLocationEntity);
			}
		}
	}
	
	public function gridSpaceEntityForLocation(x:Int, y:Int):Entity
	{
		var currentPattern:JVEnemyPattern = _dataHandler.patterns[_currentPatternIndex];
		return _grid[(x * currentPattern.gridRows) + y];
	}

	/**
	 * Private
	 */
	private var _dataHandler:JVEditorDataHandler;
	private var _currentPatternIndex:Int;
	private var _grid:Array<Entity>;
	private var _keyFrameLocationEntities:Array<Entity>;
}
