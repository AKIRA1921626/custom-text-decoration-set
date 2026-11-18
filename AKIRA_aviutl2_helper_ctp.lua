--[[
AKIRA作のAviutl2で使用する目的の各種モジュール。
]]

local M = {}

function M.line_break_confirmation() -- 現在のテキストで改行が行われた回数を確認する関数
        -- 改行の有無を確認する
        local text = obj.getvalue("テキスト","テキスト")
        local count = 1 -- ここの数値が改行が行われている回数となる。
        local i = 0
        while true do
            -- 改行の位置を検索
            i = string.find(text, "\\n", i + 1)
            if not i then break end

            -- 直前の文字を確認（インデックス i-1）
            local prev_char = string.sub(text, i - 1, i - 1,true)

            if prev_char ~= "\\" then
                count = count + 1
            end
        end
        return count -- 現在のテキストで改行が行われた回数を返す
end

function M.get_line_break_size() -- 現在のテキストでの改行のサイズを取得する関数
    -- objload("textlayout",text)用に各種値を取得し設定
    local name = obj.getvalue("テキスト","フォント")
    local size = obj.getvalue("テキスト","サイズ")
    local charspacing = obj.getvalue("テキスト","字間")
    local linespacing = obj.getvalue("テキスト","行間")
    local type = obj.getvalue("テキスト","文字装飾")
    -- 上記では、typeに""で囲まれた文字列が格納されるが、setfontには数値を引数として与える必要があるため、数値に変換。
    local text_types = {
    ["標準文字"] = 0,
    ["影付き文字"] = 1,
    ["影付き文字(薄)"] = 2,
    ["縁取り文字"] = 3,
    ["縁取り文字(細)"] = 4,
    ["縁取り文字(太)"] = 5,
    ["縁取り文字(角)"] = 6
    }
    local col1 = obj.getvalue("テキスト","文字色")
    -- 上記では、col1に"0x"が抜きの文字列が格納されるが、setfontには"0x"がついたカラーコードを引数として与える必要があるため、"0x"つきに変換。
    local used_col1 = "0x" .. col1
    local col2 = obj.getvalue("テキスト","影・縁色")
    -- 上記では、col2に"0x"が抜きの文字列が格納されるが、setfontには"0x"がついたカラーコードを引数として与える必要があるため、"0x"つきに変換。
    local used_col2 = "0x" .. col2
    local bold = obj.getvalue("テキスト","B")
    -- 上記では、boldがOFFなら0,ONなら1の数値が格納されるが、setfontにはtrue/falseを引数として与える必要があるため、true/falseに変換。
    local used_bold
    if bold ~= 0 then
        used_bold = true
    else
        used_bold = false
    end
    local italic = obj.getvalue("テキスト","I")
    -- 上記では、italicがOFFなら0,ONなら1の数値が格納されるが、setfontにはtrue/falseを引数として与える必要があるため、true/falseに変換。
    local used_italic
    if italic ~= 0 then
        used_italic = true
    else
        used_italic = false
    end

    obj.setfont(name,size,text_types[type],used_col1,used_col2,used_bold,used_italic,charspacing,linespacing)

    -- obj.load()の座標リセットを回避するため、座標保存用の変数
    local ox,oy,oz,cx,cy,cz = obj.ox,obj.oy,obj.oz,obj.cx,obj.cy,obj.cz

    local lw,lh = obj.load("textlayout","\\n")

    -- obj.load()には obj.ox, obj.oy, obj.​cx などが 0 に初期化されるというしようがあるらしい。
    -- https://x.com/sigma_axis/status/2023330969777012820
    -- そのためobj.load("textlayout",text)を使用する前に、各種座標を保存しておく。
    -- 2026/2/23のAviutl2のアップデートにより、obj.load("textlayout",text)を使用しても座標のリセットは発生しなくった。
    -- そのため現在は座標を保持するための処理は不要となるが、あっても問題はなさそうであるため一応残しておく。

    -- obj.load()の座標リセットを回避するため、座標保存用の変数を再度各座標に格納。
    obj.ox = ox
    obj.oy = oy
    obj.oz = oz
    obj.cx = cx
    obj.cy = cy
    obj.cz = cz

    return lw,lh -- 現在のテキストでの改行のサイズを返す
end

function M.get_text_size() -- 現在のテキスト全体のサイズを取得する関数
    -- objload("textlayout",text)用に各種値を取得し設定
    local name = obj.getvalue("テキスト","フォント")
    local size = obj.getvalue("テキスト","サイズ")
    local charspacing = obj.getvalue("テキスト","字間")
    local linespacing = obj.getvalue("テキスト","行間")
    local type = obj.getvalue("テキスト","文字装飾")
    local text_types = {
    ["標準文字"] = 0,
    ["影付き文字"] = 1,
    ["影付き文字(薄)"] = 2,
    ["縁取り文字"] = 3,
    ["縁取り文字(細)"] = 4,
    ["縁取り文字(太)"] = 5,
    ["縁取り文字(角)"] = 6
    }
    local col1 = obj.getvalue("テキスト","文字色")
    -- 上記では、col1に"0x"が抜きの文字列が格納されるが、setfontには"0x"がついたカラーコードを引数として与える必要があるため、"0x"つきに変換。
    local used_col1 = "0x" .. col1
    local col2 = obj.getvalue("テキスト","影・縁色")
    -- 上記では、col2に"0x"が抜きの文字列が格納されるが、setfontには"0x"がついたカラーコードを引数として与える必要があるため、"0x"つきに変換。
    local used_col2 = "0x" .. col2
    local bold = obj.getvalue("テキスト","B")
    -- 上記では、boldがOFFなら0,ONなら1の数値が格納されるが、setfontにはtrue/falseを引数として与える必要があるため、true/falseに変換。
    local used_bold
    if bold ~= 0 then
        used_bold = true
    else
        used_bold = false
    end
    local italic = obj.getvalue("テキスト","I")
    -- 上記では、italicがOFFなら0,ONなら1の数値が格納されるが、setfontにはtrue/falseを引数として与える必要があるため、true/falseに変換。
    local used_italic
    if italic ~= 0 then
        used_italic = true
    else
        used_italic = false
    end

    obj.setfont(name,size,text_types[type],used_col1,used_col2,used_bold,used_italic,charspacing,linespacing)

    -- テキストオブジェクトの中身を取得
    local text = obj.getvalue("テキスト","テキスト")

    -- obj.load()には obj.ox, obj.oy, obj.​cx などが 0 に初期化されるというしようがあるらしい。
    -- https://x.com/sigma_axis/status/2023330969777012820
    -- そのためobj.load("textlayout",text)を使用する前に、各種座標を保存しておく。
    -- 2026/2/23のAviutl2のアップデートにより、obj.load("textlayout",text)を使用しても座標のリセットは発生しなくった。
    -- そのため現在は座標を保持するための処理は不要となるが、あっても問題はなさそうであるため一応残しておく。

    -- obj.load()の座標リセットを回避するため、座標保存用の変数
    local ox,oy,oz,cx,cy,cz = obj.ox,obj.oy,obj.oz,obj.cx,obj.cy,obj.cz

    -- テキストオブジェクトの実際の中身の縦と横を取得。ここで各種座標がリセットされる。
    local w,h = obj.load("textlayout",text)

    -- obj.load()の座標リセットを回避するため、座標保存用の変数を再度各座標に格納。
    obj.ox = ox
    obj.oy = oy
    obj.oz = oz
    obj.cx = cx
    obj.cy = cy
    obj.cz = cz

    return w,h -- 現在のテキスト全体のサイズを返す
end

function M.get_text_resize() -- 現在のテキストに合わせたリサイズに使う数値を返す
    -- 改行の有無を確認する
    local text = obj.getvalue("テキスト","テキスト")
    local count = 1 -- ここの数値が改行が行われている回数となる。
    local i = 0
    while true do
        -- 改行の位置を検索
        i = string.find(text, "\\n", i + 1)
        if not i then break end

        -- 直前の文字を確認（インデックス i-1）
        local prev_char = string.sub(text, i - 1, i - 1,true)

        if prev_char ~= "\\" then
            count = count + 1
        end
    end

    -- objload("textlayout",text)用に各種値を取得し設定
    local name = obj.getvalue("テキスト","フォント")
    local size = obj.getvalue("テキスト","サイズ")
    local charspacing = obj.getvalue("テキスト","字間")
    local linespacing = obj.getvalue("テキスト","行間")
    local type = obj.getvalue("テキスト","文字装飾")
    local text_types = {
    ["標準文字"] = 0,
    ["影付き文字"] = 1,
    ["影付き文字(薄)"] = 2,
    ["縁取り文字"] = 3,
    ["縁取り文字(細)"] = 4,
    ["縁取り文字(太)"] = 5,
    ["縁取り文字(角)"] = 6
    }
    local col1 = obj.getvalue("テキスト","文字色")
    -- 上記では、col1に"0x"が抜きの文字列が格納されるが、setfontには"0x"がついたカラーコードを引数として与える必要があるため、"0x"つきに変換。
    local used_col1 = "0x" .. col1
    local col2 = obj.getvalue("テキスト","影・縁色")
    -- 上記では、col2に"0x"が抜きの文字列が格納されるが、setfontには"0x"がついたカラーコードを引数として与える必要があるため、"0x"つきに変換。
    local used_col2 = "0x" .. col2
    local bold = obj.getvalue("テキスト","B")
    -- 上記では、boldがOFFなら0,ONなら1の数値が格納されるが、setfontにはtrue/falseを引数として与える必要があるため、true/falseに変換。
    local used_bold
    if bold ~= 0 then
        used_bold = true
    else
        used_bold = false
    end
    local italic = obj.getvalue("テキスト","I")
    -- 上記では、italicがOFFなら0,ONなら1の数値が格納されるが、setfontにはtrue/falseを引数として与える必要があるため、true/falseに変換。
    local used_italic
    if italic ~= 0 then
        used_italic = true
    else
        used_italic = false
    end

    obj.setfont(name,size,text_types[type],used_col1,used_col2,used_bold,used_italic,charspacing,linespacing)

    -- テキストオブジェクトの中身を取得
    local text = obj.getvalue("テキスト","テキスト")

    -- obj.load()には obj.ox, obj.oy, obj.​cx などが 0 に初期化されるというしようがあるらしい。
    -- https://x.com/sigma_axis/status/2023330969777012820
    -- そのためobj.load("textlayout",text)を使用する前に、各種座標を保存しておく。
    -- 2026/2/23のAviutl2のアップデートにより、obj.load("textlayout",text)を使用しても座標のリセットは発生しなくった。
    -- そのため現在は座標を保持するための処理は不要となるが、あっても問題はなさそうであるため一応残しておく。

    -- obj.load()の座標リセットを回避するため、座標保存用の変数
    local ox,oy,oz,cx,cy,cz = obj.ox,obj.oy,obj.oz,obj.cx,obj.cy,obj.cz

    -- テキストオブジェクトの実際の中身の縦と横を取得。ここで各種座標がリセットされる。
    local w,h = obj.load("textlayout",text)

    -- obj.load()の座標リセットを回避するため、座標保存用の変数を再度各座標に格納。
    obj.ox = ox
    obj.oy = oy
    obj.oz = oz
    obj.cx = cx
    obj.cy = cy
    obj.cz = cz

    -- リサイズの数値の計算
    local resize
    resize = (h/100) / math.max(1,count)

return resize -- 現在のテキストに合わせたリサイズの数値
end

return M