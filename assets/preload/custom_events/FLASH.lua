function onEvent(name, value1, value2)
    if name == 'FLASH' then
        makeLuaSprite('shared/images/image', value1, 0, 0);
        addLuaSprite('shared/images/image', true);
        scaleObject('shared/images/image', 0.5, 0.52);
        doTweenColor('hello', 'shared/images/image', 'FFFFFFFF', 0.1, 'quartIn');
        setObjectCamera('shared/images/image', 'other');
        runTimer('wait', value2);
        
        function onTimerCompleted(tag, loops, loopsleft)
            if tag == 'wait' then
                doTweenAlpha('byebye', 'shared/images/image', 0, 1, 'linear');
            end
        end
        
        function onTweenCompleted(tag)
            if tag == 'byebye' then
                removeLuaSprite('shared/images/image', true);
            end
        end
    end
end