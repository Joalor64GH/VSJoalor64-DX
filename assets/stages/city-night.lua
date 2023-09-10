function onCreate()
	-- background shit
	makeLuaSprite('night', 'city/night', -600, -600);
	setLuaSpriteScrollFactor('night', 1, 1);
	
	addLuaSprite('night', false);
	scaleLuaSprite('night',1.5,1.5);

    makeLuaSprite('citynight', 'city/citynight', -600, -600);
	setLuaSpriteScrollFactor('citynight', 1, 1);
	
	addLuaSprite('citynight', false);
	scaleLuaSprite('citynight',1.5,1.5);

    makeLuaSprite('groundnight', 'city/groundnight', -600, -600);
	setLuaSpriteScrollFactor('groundnight', 1, 1);
	
	addLuaSprite('groundnight', false);
	scaleLuaSprite('groundnight',1.5,1.5);

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