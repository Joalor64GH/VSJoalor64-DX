function onCreate()
	-- background shit
	makeLuaSprite('pyramidbackground', 'stages/pyramid/pyramidbackground', -600, -600);
	setLuaSpriteScrollFactor('pyramidbackground', 1, 1);

	addLuaSprite('pyramidbackground', false);
	scaleLuaSprite('pyramidbackground',1.5,1.5);

    makeLuaSprite('pyramidground', 'stages/pyramid/pyramidground', -600, -600);
	setLuaSpriteScrollFactor('pyramidground', 1, 1);

	addLuaSprite('pyramidground', false);
	scaleLuaSprite('pyramidground',1.5,1.5);

    makeLuaSprite('curtains', 'stages/pyramid/curtains', -600, -600);
	setLuaSpriteScrollFactor('curtains', 1, 1);

	addLuaSprite('curtains', false);
	scaleLuaSprite('curtains',1.5,1.5);

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