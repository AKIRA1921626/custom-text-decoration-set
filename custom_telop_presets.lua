

local M = {}

function M.telop_presets(p, b_obj)

    local Styles = {}

    -- =============================================================================
    -- 1. 定数・カラー定義
    -- =============================================================================
    local C_WHITE      = 0xebebeb
    local C_BLACK      = 0x141414
    local C_SKIN       = 0xffc084
    local C_PALE_RED   = 0xff848a
    local C_BLOND      = 0xfbff84
    local C_PALE_GREEN = 0xc0ff84
    local C_MINT_GREEN = 0x84ff8b
    local C_PALE_BLUE  = 0x84fbff
    local C_SKY_BLUE   = 0x8491ff
    local C_LAVENDER   = 0xda84ff
    local C_PALE_PINK  = 0xff84e8

    -- 標準デコレーション(deco2-12)用のベースカラー
    local base_colors = {
        white        = 0xebebeb, -- deco2
        black        = 0x141414, -- deco3
        red          = 0xff2b2c, -- deco4
        orange       = 0xff9632, -- deco5
        yellow       = 0xfff000, -- deco6
        yellow_green = 0xb4ff3c, -- deco7
        green        = 0x00c832, -- deco8
        light_blue   = 0x32e6ff, -- deco9
        blue         = 0x1e32e6, -- deco10
        purple       = 0x9600dc, -- deco11
        pink         = 0xff1ec8, -- deco12
    }

    -- =============================================================================
    -- 2. 共通ヘルパー関数 (エフェクト生成用)
    -- =============================================================================
    -- 縁取り
    local function b(size, col) 
        return {type="縁取り", size=size, blur=10, col=col} 
    end

    -- シャドウ
    local function s(x, y, alpha, diff, col) 
        local ih = false
        if alpha == 100 and diff == 0 then ih = true end
        return {type="シャドウ", x=x, y=y, alpha=alpha, diff=diff, col=col or C_BLACK, ih=ih} 
    end

    -- ノイズ
    local function get_noise(ntype)
        return {type="ノイズ", pow=71, speedX=0, speedY=90.5, cycleX=8.15, cycleY=3.55, mode="明るさと乗算", n_type=ntype}
    end

    -- グラデーション
    local function get_grad(start_c, end_c, width, mode)
        return {type="グラデーション", pow=100, x=0, y=0, angle=0, width=width or 100, mode=mode or "通常", shape="線形", start_c=start_c, end_c=end_c}
    end

-- =============================================================================
    -- 3. 標準デコレーション生成ロジック (Styles[name][1-92])
    -- =============================================================================
    local function get_effect_template(main_col, id, color_key)
        if id == 1 then return { text_col = (color_key == "white" and C_WHITE or main_col), effects = {} } end

        local effects = {}

        -- 反転・シャドウ判定ロジックを統合した色取得関数
        local function get_smart_col(target_col)
            local final_col = target_col
            local is_white_target = (color_key == "white" and (
                (id >= 22 and id <= 27) or (id >= 30 and id <= 33) or 
                (id >= 36 and id <= 49) or (id >= 53 and id <= 54)
            ))
            local is_black_target = (color_key == "black" and (
                (id >= 6 and id <= 21) or (id >= 26 and id <= 29) or 
                (id >= 34 and id <= 35) or (id >= 55 and id <= 92)
            ))

            if is_white_target or is_black_target then
                local prev = effects[#effects]
                if not (prev and prev.type == "シャドウ") then
                    if target_col == C_WHITE then final_col = C_BLACK
                    elseif target_col == C_BLACK then final_col = C_WHITE end
                end
            end
            return final_col
        end

        -- 既存の分岐ロジックに合わせて table.insert を使用
        if id == 2 then 
            table.insert(effects, b(7, get_smart_col((color_key == "white") and C_BLACK or C_WHITE)))
        elseif id == 3 then
            table.insert(effects, b(7, get_smart_col((color_key == "white") and C_BLACK or C_WHITE))); table.insert(effects, s(10, 10, 30, 10, C_BLACK))
        elseif id == 4 then
            table.insert(effects, b(7, get_smart_col((color_key == "white") and C_BLACK or C_WHITE))); table.insert(effects, s(10, 10, 100, 0, C_BLACK) )
        elseif id == 5 then
            table.insert(effects, b(7, get_smart_col((color_key == "white") and C_BLACK or C_WHITE)))
            table.insert(effects, (color_key == "black") and s(10, 10, 100, 0, C_WHITE)  or s(10, 10, 100, 0, C_BLACK) )
            table.insert(effects, s(10, 10, 30, 10, C_BLACK))
        elseif id == 6 then
            table.insert(effects, b(7, get_smart_col(C_BLACK))); table.insert(effects, b(7, get_smart_col(C_WHITE)))
        elseif id == 7 then
            table.insert(effects, b(7, get_smart_col(C_BLACK))); table.insert(effects, b(7, get_smart_col(C_WHITE))); table.insert(effects, s(10, 10, 30, 10, C_BLACK))
        elseif id >= 8 and id <= 9 then
            table.insert(effects, b(7, get_smart_col(C_BLACK))); table.insert(effects, b(7, get_smart_col(C_WHITE))); table.insert(effects, s(10, 10, 100, 0, C_BLACK) )
            if id == 9 then table.insert(effects, s(10, 10, 30, 10, C_BLACK)) end
        elseif id >= 10 and id <= 13 then
            table.insert(effects, b(7, get_smart_col(C_BLACK))); table.insert(effects, (color_key == "white") and s(10, 10, 100, 0, C_BLACK)  or s(10, 10, 100, 0, C_WHITE) ); table.insert(effects, b(7, get_smart_col(C_WHITE)))
            if id == 11 or id == 13 then table.insert(effects, s(10, 10, 30, 10, C_BLACK)) end
        elseif id == 14 or id == 15 then
            table.insert(effects, b(7, get_smart_col(C_BLACK)))
            if id == 15 then table.insert(effects, s(10, 10, 30, 10, C_BLACK)) end
        elseif id == 16 or id == 17 then
            table.insert(effects, s(10, 10, 100, 0, C_BLACK) ); table.insert(effects, b(7, get_smart_col(C_BLACK)))
            if id == 17 then table.insert(effects, s(10, 10, 30, 10, C_BLACK)) end
        elseif id == 18 or id == 19 then
            table.insert(effects, b(7, get_smart_col(C_BLACK))); table.insert(effects, b(7, get_smart_col(C_WHITE)))
            if id == 19 then table.insert(effects, s(10, 10, 30, 10, C_BLACK)) end
        elseif id == 20 or id == 21 then
            table.insert(effects, b(7, get_smart_col(C_BLACK))); table.insert(effects, s(10, 10, 100, 0, C_BLACK) ); table.insert(effects, b(7, get_smart_col(C_WHITE)))
            if id == 21 then table.insert(effects, s(10, 10, 30, 10, C_BLACK)) end
        elseif id >= 22 and id <= 23 then
            table.insert(effects, b(7, get_smart_col(C_WHITE))); table.insert(effects, b(7, main_col))
            if id == 23 then table.insert(effects, s(10, 10, 30, 10, C_BLACK)) end
        elseif id >= 24 and id <= 25 then
            table.insert(effects, b(7, get_smart_col(C_WHITE))); table.insert(effects, s(7, 7, 100, 0, main_col)); table.insert(effects, b(7, main_col))
            if id == 25 then table.insert(effects, s(10, 10, 30, 10, C_BLACK)) end
        elseif id >= 26 and id <= 27 then
            table.insert(effects, s(10, 10, 100, 0, C_BLACK) ); table.insert(effects, b(7, get_smart_col(C_WHITE))); table.insert(effects, b(7, main_col))
            if id == 27 then table.insert(effects, s(10, 10, 30, 10, C_BLACK)) end
        elseif id >= 28 and id <= 29 then
            table.insert(effects, s(10, 10, 100, 0, C_BLACK) ); table.insert(effects, b(7, get_smart_col(C_BLACK))); table.insert(effects, b(7, get_smart_col(C_WHITE))); table.insert(effects, b(7, main_col))
            if id == 29 then table.insert(effects, s(10, 10, 30, 10, C_BLACK)) end
        elseif id >= 30 and id <= 31 then
            table.insert(effects, b(7, get_smart_col(C_WHITE))); table.insert(effects, s(7, 7, 100, 0, main_col)); table.insert(effects, b(7, get_smart_col(C_BLACK))); table.insert(effects, b(7, get_smart_col(C_WHITE))); table.insert(effects, b(7, main_col))
            if id == 31 then table.insert(effects, s(10, 10, 30, 10, C_BLACK)) end
        elseif id >= 32 and id <= 33 then
            table.insert(effects, b(7, get_smart_col(C_WHITE))); table.insert(effects, s(10, 10, 100, 0, C_BLACK) ); table.insert(effects, b(7, get_smart_col(C_BLACK))); table.insert(effects, b(7, get_smart_col(C_WHITE)))
            table.insert(effects, (color_key == "black") and b(7, get_smart_col(C_WHITE)) or b(7, main_col))
            if id == 33 then table.insert(effects, s(10, 10, 30, 10, C_BLACK)) end
        elseif id == 34 or id == 35 then
            table.insert(effects, b(14, get_smart_col(C_BLACK))); table.insert(effects, b(7, get_smart_col(C_WHITE)))
            table.insert(effects, s(10, 10, 100, 0, C_BLACK) ); table.insert(effects, b(7, get_smart_col(C_BLACK))); table.insert(effects, b(7, get_smart_col(C_WHITE)))
            if id == 35 then table.insert(effects, s(10, 10, 30, 10, C_BLACK)) end
        elseif id >= 36 and id <= 37 then
            table.insert(effects, s(10, 10, 100, 0, C_WHITE) ); table.insert(effects, b(7, get_smart_col(C_WHITE))); table.insert(effects, b(7, main_col))
            if id == 37 then table.insert(effects, s(10, 10, 30, 10, C_BLACK)) end
        elseif id >= 38 and id <= 43 then
            table.insert(effects, s(10, 10, 100, 0, C_WHITE) ); table.insert(effects, b(7, get_smart_col(C_WHITE)))
            if id == 38 or id == 39 then table.insert(effects, s(7, 7, 100, 0, main_col)) end
            if id == 40 or id == 41 then table.insert(effects, s(7, 7, 100, 0, main_col)) end
            if id == 42 or id == 43 then table.insert(effects, s(10, 10, 100, 0, C_BLACK) ) end
            table.insert(effects, (id >= 40) and b(7, get_smart_col(C_BLACK)) or b(7, main_col))
            if id % 2 ~= 0 then table.insert(effects, s(10, 10, 30, 10, C_BLACK)) end
        elseif id == 44 or id == 45 then
            table.insert(effects, b(20, get_smart_col(C_WHITE))); table.insert(effects, b(7, get_smart_col(C_BLACK)))
            if id == 45 then table.insert(effects, s(10, 10, 30, 10, C_BLACK)) end
        elseif id == 46 or id == 47 then
            table.insert(effects, s(10, 10, 100, 0, C_WHITE) ); table.insert(effects, b(7, get_smart_col(C_WHITE))); table.insert(effects, b(7, get_smart_col(C_BLACK))); table.insert(effects, b(7, get_smart_col(C_WHITE)))
            if id == 47 then table.insert(effects, s(10, 10, 30, 10, C_BLACK)) end
        elseif id == 48 or id == 49 then
            table.insert(effects, b(7, get_smart_col(C_WHITE))); table.insert(effects, {type="縁取り", size=30, blur=70, col=get_smart_col(C_WHITE)})
            if id == 49 then table.insert(effects, s(10, 10, 30, 10, C_BLACK)) end
        elseif id == 50 then
            table.insert(effects, s(0, 0, 50, 10, C_BLACK))
        elseif id == 51 or id == 52 then
            table.insert(effects, {type="縁取り", size=50, blur=100, col=get_smart_col(color_key == "white" and C_WHITE or C_BLACK)})
            if id == 52 then table.insert(effects, s(10, 10, 30, 10, C_BLACK)) end
    -- 53-54: b(20, WHITE)
        elseif id >= 53 and id <= 54 then
            table.insert(effects, b(20, get_smart_col(C_WHITE)))
            if id == 54 then table.insert(effects, s(10, 10, 30, 10, C_BLACK)) end

        -- 55-56: b(20, WHITE) + b(7, BLACK)
        elseif id >= 55 and id <= 56 then
            table.insert(effects, b(20, get_smart_col(C_WHITE)))
            table.insert(effects, b(7, get_smart_col(C_BLACK)))
            if id == 56 then table.insert(effects, s(10, 10, 30, 10, C_BLACK)) end

        -- 57-58: b(20, WHITE) + b(7, BLACK) + s(10, 10, 100, 0, C_BLACK) 
        elseif id >= 57 and id <= 58 then
            table.insert(effects, b(20, get_smart_col(C_WHITE)))
            table.insert(effects, b(7, get_smart_col(C_BLACK)))
            table.insert(effects, s(10, 10, 100, 0, C_BLACK) )
            if id == 58 then table.insert(effects, s(10, 10, 30, 10, C_BLACK)) end

        -- 59-60 (旧55-56): b(20, BLACK) + b(7, WHITE) + s(10, 10, 100, 0, C_WHITE) 
        elseif id >= 59 and id <= 60 then
            table.insert(effects, b(20, get_smart_col(C_BLACK)))
            table.insert(effects, b(7, get_smart_col(C_WHITE)))
            table.insert(effects, s(10, 10, 100, 0, C_WHITE) )
            if id == 60 then table.insert(effects, s(10, 10, 30, 10, C_BLACK)) end

        -- 61-78 (旧57-74): カラー縁取りシリーズ 1
        elseif id >= 61 and id <= 78 then
            table.insert(effects, b(7, get_smart_col(C_BLACK)))
            local col_map = {C_PALE_RED, C_SKIN, C_BLOND, C_PALE_GREEN, C_MINT_GREEN, C_PALE_BLUE, C_SKY_BLUE, C_LAVENDER, C_PALE_PINK}
            local col_idx = math.floor((id - 61) / 2) + 1
            table.insert(effects, {type="縁取り", size=30, blur=70, col=col_map[col_idx]})
            if id % 2 == 0 then table.insert(effects, s(10, 10, 30, 10, C_BLACK)) end

        -- 79-96 (旧75-92): カラー縁取りシリーズ 2
        elseif id >= 79 and id <= 96 then
            table.insert(effects, b(7, get_smart_col(C_BLACK)))
            table.insert(effects, b(7, get_smart_col(C_WHITE)))
            table.insert(effects, b(7, get_smart_col(C_BLACK)))
            local col_map = {C_PALE_RED, C_SKIN, C_BLOND, C_PALE_GREEN, C_MINT_GREEN, C_PALE_BLUE, C_SKY_BLUE, C_LAVENDER, C_PALE_PINK}
            local col_idx = math.floor((id - 79) / 2) + 1
            table.insert(effects, {type="縁取り", size=30, blur=70, col=col_map[col_idx]})
            if id % 2 == 0 then table.insert(effects, s(10, 10, 30, 10, C_BLACK)) end
        end

        return { text_col = (color_key == "white" and C_WHITE or main_col), effects = effects }
    end

    -- 標準カテゴリ(deco2-12)をループで一括生成
    for name, main_col in pairs(base_colors) do
        Styles[name] = {}
        for i = 1, 96 do
            Styles[name][i] = get_effect_template(main_col, i, name)
        end
    end

-- =============================================================================
    -- 4. グラデーション装飾 (deco13用)
    -- =============================================================================
    Styles.gradation = { [1] = { text_col = C_WHITE, effects = {} } }
    
    local s_std  = s(10, 10, 30, 10)
    local s_hard = s(7, 7, 100, 0)

    -- グラデーション基本設定リスト
    local g_bases = {
        {sc=0xff9632, ec=0xffffff, w=100, sh="線形"}, -- 1(A): 橙白
        {sc=0xffffff, ec=0x1e64c8, w=100, sh="凸型"}, -- 2(B): 白青
        {sc=0xffffff, ec=0x4c4c4c, w=30,  sh="凸型"}, -- 3(C): 白灰
        {sc=0xfaff42, ec=0xffd126, w=20,  sh="凸型"}, -- 4(D): 黄橙
        {sc=0xff3621, ec=0xde471d, w=100, sh="線形"}, -- 5(E): 赤朱 (反転対象)
        {sc=0xff2b2c, ec=0xebebeb, w=100, sh="線形"}, -- 6(F): 赤白
        {sc=0x1e32e6, ec=0x0a0a0a, w=20,  sh="線形"}, -- 7(G): 青黒 (反転対象)
        {sc=0x2caa13, ec=0x21ff51, w=20,  sh="線形"}, -- 8 緑
        {sc=0x1398aa, ec=0x21ffed, w=20,  sh="線形"}, -- 9 水色
        {sc=0x132faa, ec=0x3c21ff, w=20,  sh="線形"}, -- 10 青
        {sc=0x8113aa, ec=0x9b21ff, w=20,  sh="線形"}, -- 11 紫
        {sc=0xc216a4, ec=0xff21c7, w=20,  sh="線形"}, -- 12 ピンク
        {sc=0xff842b, ec=0xff5c21, w=20,  sh="線形"}, -- 13 オレンジ
        {sc=0xfff521, ec=0xffdd2b, w=20,  sh="線形"}, -- 14 黄色
        {sc=0x2bff26, ec=0xf3ff2b, w=20,  sh="線形"}, -- 15 緑黄色
        {sc=0x26fff6, ec=0xf3ff2b, w=20,  sh="線形"}, -- 16 水色黄色
        {sc=0x2697ff, ec=0x2bf0ff, w=20,  sh="線形"}, -- 17 青水色
        {sc=0x2697ff, ec=0x472bff, w=20,  sh="線形"}, -- 18 水色青
    }

    -- 全パターン生成 (7種 × 20パターン = 140種類)
    for b_idx, base in ipairs(g_bases) do
        
        -- 条件: 5(E)と7(G)のときだけ反転フラグを立てる
        local should_invert = (b_idx == 5 or b_idx == 7)

        -- 既存の装飾パターン構造 (元の定数 C_WHITE, C_BLACK を使用)
        local current_decorations = {
            [1]={}, [2]={}, [3]={b(7,C_WHITE)}, [4]={b(7,C_BLACK),s_std},
            [5]={b(7,C_BLACK),b(7,C_WHITE)}, [6]={b(7,C_BLACK),b(7,C_WHITE),s_std},
            [7]={b(7,C_BLACK),s_hard,b(7,C_WHITE)}, [8]={b(7,C_BLACK),s_hard,b(7,C_WHITE),s_std},
            [9]={b(7,C_BLACK),b(7,C_SKIN)}, [10]={b(7,C_BLACK),b(7,C_SKIN),s_std},
            [11]={b(7,C_BLACK),s(7,7,100,0,C_SKIN),b(7,C_SKIN)}, [12]={b(7,C_BLACK),s(7,7,100,0,C_SKIN),b(7,C_SKIN),s_std},
            [13]={s_hard,b(7,C_BLACK),b(7,C_WHITE),b(7,C_SKIN)}, [14]={s_hard,b(7,C_BLACK),b(7,C_WHITE),b(7,C_SKIN),s_std},
            [15]={b(7,C_BLACK),s_hard,b(3,C_BLACK),b(7,C_WHITE),b(7,C_SKIN)}, [16]={b(7,C_BLACK),s_hard,b(3,C_BLACK),b(7,C_WHITE),b(7,C_SKIN),s_std},
            [17]={b(20,C_BLACK),b(3,C_WHITE)}, [18]={b(20,C_BLACK),b(3,C_WHITE),s_std},
            [19]={b(20,C_BLACK),s_hard,b(3,C_BLACK),b(20,C_WHITE)}, [20]={b(20,C_BLACK),s_hard,b(3,C_BLACK),b(20,C_WHITE),s_std}
        }

        for d_idx, effs in ipairs(current_decorations) do
            local target_idx = (b_idx - 1) * 20 + d_idx
            local grad_effect = {
                type="グラデーション", pow=100, x=0, y=0, angle=0, 
                width=base.w, mode="通常", shape=base.sh, 
                start_c=base.sc, end_c=base.ec
            }
            local final_effs = { grad_effect }

            for i, v in ipairs(effs) do
                local processed_v = v
                -- 反転条件を満たし、かつエフェクトが「縁取り」の場合のみ判定
                if should_invert and v.type == "縁取り" then
                    -- 直前のエフェクト(final_effsの最後)を確認
                    local prev_eff = final_effs[#final_effs]
                    -- 直前が「シャドウ」でない場合のみ、白と黒を反転させる
                    if prev_eff.type ~= "シャドウ" then
                        if v.col == C_WHITE then
                            processed_v = {type="縁取り", size=v.size, blur=v.blur, col=C_BLACK}
                        elseif v.col == C_BLACK then
                            processed_v = {type="縁取り", size=v.size, blur=v.blur, col=C_WHITE}
                        end
                    end
                end
                table.insert(final_effs, processed_v)
            end
            
            Styles.gradation[target_idx] = { text_col = base.sc, effects = final_effs }
        end
    end

    -- =============================================================================
    -- 5. 特殊テロップ (deco14用) - 整理済み
    -- =============================================================================
    Styles.special = { [1] = { text_col = C_WHITE, effects = {} } }

    -- [2-6] 特殊グラデーション系列
    local sp_grad = get_grad(0xff0000, 0x8e8e37, 43, "加算")
    local base_a  = { get_noise(2), sp_grad }
    local patterns_a = {
        [2] = {},
        [3] = { b(7, 0xebebeb) },
        [4] = { b(7, 0xebebeb), b(7, 0xd50c0c) },
        [5] = { b(7, 0xebebeb), b(7, 0xd50c0c), s(7, 7, 100, 0), b(7, 0x141414) },
        [6] = { b(7, 0xebebeb), b(7, 0xd50c0c), s(7, 7, 100, 0), b(7, 0x141414), s(10, 10, 30, 10) }
    }
    for i, effs in pairs(patterns_a) do
        local final_effs = { unpack(base_a) }
        for _, e in ipairs(effs) do table.insert(final_effs, e) end
        Styles.special[i] = { text_col = 0xff9632, effects = final_effs }
    end

    -- [7以降] 色バリエーション系列
    local sp_colors = {0xff2b2c, 0xff9632, 0xf7ff2b, 0x2bff2b, 0x39ffff, 0x2626ff, 0xba26ff, 0xff26b1}
    local cur_idx = 7
    for _, col in ipairs(sp_colors) do
        local noise = get_noise(3)
        Styles.special[cur_idx]     = { text_col = col, effects = { noise } }
        Styles.special[cur_idx + 1] = { text_col = col, effects = { noise, b(3, 0xebebeb) } }
        Styles.special[cur_idx + 2] = { text_col = col, effects = { noise, b(3, 0xebebeb), s(7, 7, 100, 0), b(7, 0x141414) } }
        Styles.special[cur_idx + 3] = { text_col = col, effects = { noise, b(3, 0xebebeb), s(7, 7, 100, 0), b(7, 0x141414), s(10, 10, 30, 10) } }
        cur_idx = cur_idx + 4
    end

    -- =============================================================================
    -- 6. データ選択ロジック
    -- =============================================================================
    local data = { text_col = nil, effects = {} }

    if     (p.deco14 and p.deco14 ~= 1) then data = Styles.special[p.deco14]
    elseif (p.deco13 and p.deco13 ~= 1) then data = Styles.gradation[p.deco13]
    elseif (p.deco12 and p.deco12 ~= 1) then data = Styles.pink[p.deco12]
    elseif (p.deco11 and p.deco11 ~= 1) then data = Styles.purple[p.deco11]
    elseif (p.deco10 and p.deco10 ~= 1) then data = Styles.blue[p.deco10]
    elseif (p.deco9  and p.deco9  ~= 1) then data = Styles.light_blue[p.deco9]
    elseif (p.deco8  and p.deco8  ~= 1) then data = Styles.green[p.deco8]
    elseif (p.deco7  and p.deco7  ~= 1) then data = Styles.yellow_green[p.deco7]
    elseif (p.deco6  and p.deco6  ~= 1) then data = Styles.yellow[p.deco6]
    elseif (p.deco5  and p.deco5  ~= 1) then data = Styles.orange[p.deco5]
    elseif (p.deco4  and p.deco4  ~= 1) then data = Styles.red[p.deco4]
    elseif (p.deco3  and p.deco3  ~= 1) then data = Styles.black[p.deco3]
    elseif (p.deco2  and p.deco2  ~= 1) then data = Styles.white[p.deco2]
    end

    -- =============================================================================
    -- 7. AviUtlオブジェクトへの反映 (描画)
    -- =============================================================================
    if data.text_col then
        local c = data.text_col; if p.cen==1 then c = p.ct end
        obj.effect("単色化", "強さ", 100, "色", c, "輝度を保持する", 0)
    end

    -- ユーザー定義の追加グラデーションロジックを実行 (.anm2から渡された場合)
    if p.custom_grad_func then
        p.custom_grad_func()
    end

    local bi = 1
    local has_s_std = false
    local has_s_hard = false

    for _, eff in ipairs(data.effects) do
        if not eff then break end
        
        if eff.type == "縁取り" then
            local c = eff.col
            local s = eff.size
            local draw = true
            
            if bi == 1 then
                if p.cb1_en == 1 then c = p.cb1 end
                if p.b1 > -1 then 
                    s = p.b1
                    if p.b1 == 0 then draw = false end
                end
            elseif bi == 2 then
                if p.cb2_en == 1 then c = p.cb2 end
                if p.b2 > -1 then 
                    s = p.b2
                    if p.b2 == 0 then draw = false end
                end
            elseif bi == 3 then
                if p.cb3_en == 1 then c = p.cb3 end
                if p.b3 > -1 then 
                    s = p.b3
                    if p.b3 == 0 then draw = false end
                end
            end
            
            if draw then
                obj.effect("縁取り", "サイズ", s * p.prisets_resize, "ぼかし", eff.blur, "縁色", c)
            end
            bi = bi + 1
            
        elseif eff.type == "シャドウ" then
            local c = eff.col
            local draw = true
            
            if eff.ih then
                has_s_hard = true
                if p.chs_en == 1 then c = p.chs end
                local a = eff.alpha
                if p.ha > -1 then
                    a = p.ha
                    if a == 0 then draw = false end
                end
                if draw then
                    obj.effect("ドロップシャドウ", "X", p.hx * p.prisets_resize, "Y", p.hy * p.prisets_resize, "濃さ", a, "拡散", 0, "影色", c)
                end
            else
                has_s_std = true
                if p.cs_en == 1 then c = p.cs end
                local a = eff.alpha
                if p.sa > -1 then
                    a = p.sa
                    if a == 0 then draw = false end
                end
                if draw then
                    obj.effect("ドロップシャドウ", "X", p.sx * p.prisets_resize, "Y", p.sy * p.prisets_resize, "濃さ", a, "拡散", p.sd, "影色", c)
                end
            end
        elseif eff.type == "ノイズ" then
            obj.effect("ノイズ", "強さ", eff.pow, "速度X", eff.speedX, "速度Y", eff.speedY, "周期X", eff.cycleX, "周期Y", eff.cycleY, "合成モード", eff.mode, "ノイズの種類", eff.n_type)
        elseif eff.type == "グラデーション" then
            obj.effect("グラデーション", "強さ", eff.pow, "中心X", eff.x, "中心Y", eff.y, "角度", eff.angle, "幅", eff.width * p.prisets_resize, "合成モード", eff.mode, "形状", eff.shape, "開始色", eff.start_c, "終了色", eff.end_c)
        end
    end

    -- 追加指定の縁取りを描画 (指定されたが存在しなかった場合)
    if (p.b1 > 0 or p.cb1_en == 1) and bi <= 1 then
        local s = (p.b1 > -1) and p.b1 or 7
        if s > 0 then
            local c = (p.cb1_en == 1) and p.cb1 or C_BLACK
            obj.effect("縁取り", "サイズ", s * p.prisets_resize, "ぼかし", 10, "縁色", c)
            bi = bi + 1
        end
    end
    if (p.b2 > 0 or p.cb2_en == 1) and bi <= 2 then
        local s = (p.b2 > -1) and p.b2 or 14
        if s > 0 then
            local c = (p.cb2_en == 1) and p.cb2 or C_WHITE
            obj.effect("縁取り", "サイズ", s * p.prisets_resize, "ぼかし", 10, "縁色", c)
            bi = bi + 1
        end
    end
    if (p.b3 > 0 or p.cb3_en == 1) and bi <= 3 then
        local s = (p.b3 > -1) and p.b3 or 20
        if s > 0 then
            local c = (p.cb3_en == 1) and p.cb3 or C_BLACK
            obj.effect("縁取り", "サイズ", s * p.prisets_resize, "ぼかし", 10, "縁色", c)
            bi = bi + 1
        end
    end


    -- 追加指定のシャドウを描画 (指定されたが存在しなかった場合)
    if not has_s_hard and (p.ha > 0 or p.chs_en == 1) then
        local a = (p.ha > -1) and p.ha or 100
        if a > 0 then
            local c = (p.chs_en == 1) and p.chs or C_BLACK
            obj.effect("ドロップシャドウ", "X", p.hx * p.prisets_resize, "Y", p.hy * p.prisets_resize, "濃さ", a, "拡散", 0, "影色", c)
        end
    end
    if not has_s_std and (p.sa > 0 or p.cs_en == 1) then
        local a = (p.sa > -1) and p.sa or 30
        if a > 0 then
            local c = (p.cs_en == 1) and p.cs or C_BLACK
            obj.effect("ドロップシャドウ", "X", p.sx * p.prisets_resize, "Y", p.sy * p.prisets_resize, "濃さ", a, "拡散", p.sd, "影色", c)
        end
    end

end

return M