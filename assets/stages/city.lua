function onCreate()
	-- background shit
	makeLuaSprite('sky', 'stages/city/sky', -600, -600);
	setLuaSpriteScrollFactor('sky', 1, 1);

	addLuaSprite('sky', false);
	scaleLuaSprite('sky',1.5,1.5);

    makeLuaSprite('city', 'stages/city/city', -600, -600);
	setLuaSpriteScrollFactor('city', 1, 1);

	addLuaSprite('city', false);
	scaleLuaSprite('city',1.5,1.5);

    makeLuaSprite('ground', 'stages/city/ground', -600, -600);
	setLuaSpriteScrollFactor('ground', 1, 1);

	addLuaSprite('ground', false);
	scaleLuaSprite('ground',1.5,1.5);

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