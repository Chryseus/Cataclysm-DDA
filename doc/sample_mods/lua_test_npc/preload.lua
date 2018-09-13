function message(...)
    local s = string.format(...)
    game.add_msg(s)
end

function iuse_test_npc(item, active)
    local um
    local feature

    -- Create select menu
    um = game.create_uimenu()
    um.title = "What do you do?"
    um:addentry("Check NPC's opinion")
    um:addentry("Make NPC angry")
    um:addentry("Cancel")
    -- Wait for player selection
    um:query(true)

    if um.selected == npc_num then
        -- Canceled
        return 0
    end
    feature = um.selected

    local p = player:pos()
    local delta_x
    local delta_y
    local npc_num = 0
    local npcs = {}
    local npc

    -- Create select menu
    um = game.create_uimenu()
    um.title = "Select NPC"
    -- Search NPCs around you
    for delta_x = -1, 1 do
        for delta_y = -1, 1 do
            local tp = tripoint(p.x + delta_x, p.y + delta_y, p.z)
            npc = game.get_npc_at(tp)
            if npc then
                um:addentry(npc:get_name())
                table.insert(npcs, npc)
                npc_num = npc_num + 1
            end
        end
    end
    um:addentry("Cancel")
    -- Wait for player selection
    um:query(true)

    if um.selected == npc_num then
        -- Canceled
        return 0
    end

    local target = npcs[um.selected + 1]
    if feature == 0 then
        local opinion = target.op_of_u
        Message("Trust: %d", opinion.trust)
        Message("Fear: %d", opinion.fear)
        Message("Value: %d", opinion.value)
        Message("Anger: %d", opinion.anger)
        Message("Owed: %d", opinion.owed)
    elseif feature == 1 then
        target:make_angry()
        Message("%s gets angry!", target:disp_name())
    end

    return 0
end

game.register_iuse("TEST_NPC", iuse_test_npc)
