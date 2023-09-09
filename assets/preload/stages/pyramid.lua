function onCreate()
	-- background shit
	makeLuaSprite('pyramidinside', 'pyramid/pyramidinside', -600, -600);
	setLuaSpriteScrollFactor('pyramidinside', 1, 1);
	
	addLuaSprite('pyramidinside', false);
	scaleLuaSprite('pyramidinside',1.5,1.5);

    makeLuaSprite('pyramidground', 'pyramid/pyramidground', -600, -600);
	setLuaSpriteScrollFactor('pyramidground', 1, 1);
	
	addLuaSprite('pyramidground', false);
	scaleLuaSprite('pyramidground',1.5,1.5);

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