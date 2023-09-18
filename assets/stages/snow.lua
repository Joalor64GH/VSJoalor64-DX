function onCreate()
	-- background shit
	makeLuaSprite('sky', 'stages/snow/snowySky', -600, -600);
	setLuaSpriteScrollFactor('sky', 1, 1);
	
	addLuaSprite('sky', false);
	scaleLuaSprite('sky',1.5,1.5);

    makeLuaSprite('buildings', 'stages/snow/buildings', -600, -600);
	setLuaSpriteScrollFactor('buildings', 1, 1);
	
	addLuaSprite('buildings', false);
	scaleLuaSprite('buildings',1.5,1.5);

    makeLuaSprite('bgSnow', 'stages/snow/snowBehind', -600, -600);
	setLuaSpriteScrollFactor('bgSnow', 1, 1);
	
	addLuaSprite('bgSnow', false);
	scaleLuaSprite('bgSnow',1.5,1.5);

    makeLuaSprite('ground', 'stages/snow/snow', -600, -600);
	setLuaSpriteScrollFactor('ground', 1, 1);
	
	addLuaSprite('ground', false);
	scaleLuaSprite('ground',1.5,1.5);

    makeAnimatedLuaSprite('snowing', 'stages/snow/snowfall', 0, 0);
	setLuaSpriteScrollFactor('snowing', 0.3, 0.3);
	scaleObject('snowing', 5, 5);

	addLuaSprite('snowing', true);
	addAnimationByPrefix('snowing', 'loop', 'anim', 15, true);

end

function onMoveCamera(focus)
    if focus == 'dad' then
        setProperty('camFollow.y', getProperty('camFollow.y') -50);
        setProperty('camFollow.x', getProperty('camFollow.x') +200);
    elseif focus == 'boyfriend' then
        setProperty('camFollow.y', getProperty('camFollow.y') -200);
        setProperty('camFollow.x', getProperty('camFollow.x') -300);
    end
end