local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Library = {
    Options = {}
}

function Library:Notify(cfg)
    cfg = cfg or {}
    local title = cfg.Title or "Notification"
    local content = cfg.Content or ""
    local duration = cfg.Duration or 3
    
    local gui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("LibraryNotifyGui")
    if not gui then
        gui = Instance.new("ScreenGui")
        gui.Name = "LibraryNotifyGui"
        gui.ResetOnSpawn = false
        gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        
        local holder = Instance.new("Frame")
        holder.Name = "Holder"
        holder.Size = UDim2.new(0, 250, 1, -20)
        holder.Position = UDim2.new(1, -260, 0, 10)
        holder.BackgroundTransparency = 1
        holder.Parent = gui
        
        local layout = Instance.new("UIListLayout")
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 8)
        layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        layout.Parent = holder
    end
    
    local holder = gui:FindFirstChild("Holder")
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 60)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    frame.BorderSizePixel = 0
    frame.Parent = holder
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local tLabel = Instance.new("TextLabel")
    tLabel.Size = UDim2.new(1, -16, 0, 20)
    tLabel.Position = UDim2.new(0, 8, 0, 6)
    tLabel.BackgroundTransparency = 1
    tLabel.Text = title
    tLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    tLabel.TextXAlignment = Enum.TextXAlignment.Left
    tLabel.Font = Enum.Font.SourceSansBold
    tLabel.TextSize = 15
    tLabel.Parent = frame
    
    local cLabel = Instance.new("TextLabel")
    cLabel.Size = UDim2.new(1, -16, 0, 30)
    cLabel.Position = UDim2.new(0, 8, 0, 24)
    cLabel.BackgroundTransparency = 1
    cLabel.Text = content
    cLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    cLabel.TextXAlignment = Enum.TextXAlignment.Left
    cLabel.TextWrapped = true
    cLabel.Font = Enum.Font.SourceSans
    cLabel.TextSize = 13
    cLabel.Parent = frame
    
    task.spawn(function()
        task.wait(duration)
        frame:Destroy()
    end)
end

function Library:CreateWindow(cfg)
    cfg = cfg or {}
    local title = cfg.Title or "Window"
    local subTitle = cfg.SubTitle or ""
    local minKey = cfg.MinimizeKey or Enum.KeyCode.RightControl
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LibraryWindowGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    local main = Instance.new("Frame")
    main.Name = "MainFrame"
    main.Size = cfg.Size or UDim2.new(0, 550, 0, 350)
    main.Position = UDim2.new(0.5, -275, 0.5, -175)
    main.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
    main.BorderSizePixel = 0
    main.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = main
    
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 40)
    topBar.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    topBar.BorderSizePixel = 0
    topBar.Parent = main
    
    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, 8)
    topCorner.Parent = topBar
    
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(0, 250, 1, 0)
    titleLbl.Position = UDim2.new(0, 12, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title .. (subTitle ~= "" and (" | " .. subTitle) or "")
    titleLbl.TextColor3 = Color3.fromRGB(240, 240, 240)
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Font = Enum.Font.SourceSansBold
    titleLbl.TextSize = 16
    titleLbl.Parent = topBar
    
    local dragging, dragInput, dragStart, startPos
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    local tabWidth = cfg.TabWidth or 130
    local sidebar = Instance.new("ScrollingFrame")
    sidebar.Size = UDim2.new(0, tabWidth, 1, -40)
    sidebar.Position = UDim2.new(0, 0, 0, 40)
    sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    sidebar.BorderSizePixel = 0
    sidebar.ScrollBarThickness = 2
    sidebar.Parent = main
    
    local sideLayout = Instance.new("UIListLayout")
    sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sideLayout.Padding = UDim.new(0, 4)
    sideLayout.Parent = sidebar
    
    local sidePadding = Instance.new("UIPadding")
    sidePadding.PaddingTop = UDim.new(0, 6)
    sidePadding.PaddingLeft = UDim.new(0, 6)
    sidePadding.PaddingRight = UDim.new(0, 6)
    sidePadding.Parent = sidebar
    
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -tabWidth, 1, -40)
    container.Position = UDim2.new(0, tabWidth, 0, 40)
    container.BackgroundTransparency = 1
    container.Parent = main
    
    local Window = {
        Tabs = {},
        ActiveTab = nil,
        Minimized = false
    }
    
    function Window:Minimize()
        Window.Minimized = true
        main.Visible = false
    end
    
    function Window:Maximize()
        Window.Minimized = false
        main.Visible = true
    end
    
    function Window:Destroy()
        screenGui:Destroy()
    end
    
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == minKey then
            if Window.Minimized then
                Window:Maximize()
            else
                Window:Minimize()
            end
        end
    end)
    
    function Window:SelectTab(tabObj)
        for _, t in ipairs(Window.Tabs) do
            t.Frame.Visible = false
            t.Btn.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
            t.Btn.TextColor3 = Color3.fromRGB(160, 160, 160)
        end
        tabObj.Frame.Visible = true
        tabObj.Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        tabObj.Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Window.ActiveTab = tabObj
    end
    
    function Window:AddTab(tabCfg)
        tabCfg = tabCfg or {}
        local tabTitle = tabCfg.Title or "Tab"
        
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1, 0, 0, 30)
        tabBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
        tabBtn.BorderSizePixel = 0
        tabBtn.Text = tabTitle
        tabBtn.TextColor3 = Color3.fromRGB(160, 160, 160)
        tabBtn.Font = Enum.Font.SourceSans
        tabBtn.TextSize = 14
        tabBtn.Parent = sidebar
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 4)
        tabCorner.Parent = tabBtn
        
        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 4
        page.Visible = false
        page.Parent = container
        
        local pageLayout = Instance.new("UIListLayout")
        pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        pageLayout.Padding = UDim.new(0, 6)
        pageLayout.Parent = page
        
        local pagePadding = Instance.new("UIPadding")
        pagePadding.PaddingTop = UDim.new(0, 8)
        pagePadding.PaddingLeft = UDim.new(0, 8)
        pagePadding.PaddingRight = UDim.new(0, 8)
        pagePadding.PaddingBottom = UDim.new(0, 8)
        pagePadding.Parent = page
        
        local Tab = {
            Frame = page,
            Btn = tabBtn
        }
        
        tabBtn.MouseButton1Click:Connect(function()
            Window:SelectTab(Tab)
        end)
        
        function Tab:AddSection(secTitle)
            local sec = Instance.new("TextLabel")
            sec.Size = UDim2.new(1, 0, 0, 22)
            sec.BackgroundTransparency = 1
            sec.Text = secTitle
            sec.TextColor3 = Color3.fromRGB(120, 120, 130)
            sec.TextXAlignment = Enum.TextXAlignment.Left
            sec.Font = Enum.Font.SourceSansBold
            sec.TextSize = 13
            sec.Parent = page
            return sec
        end
        
        function Tab:AddParagraph(pCfg)
            pCfg = pCfg or {}
            local pFrame = Instance.new("Frame")
            pFrame.Size = UDim2.new(1, 0, 0, 50)
            pFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
            pFrame.BorderSizePixel = 0
            pFrame.Parent = page
            
            local pCorner = Instance.new("UICorner")
            pCorner.CornerRadius = UDim.new(0, 6)
            pCorner.Parent = pFrame
            
            local tL = Instance.new("TextLabel")
            tL.Size = UDim2.new(1, -12, 0, 20)
            tL.Position = UDim2.new(0, 6, 0, 4)
            tL.BackgroundTransparency = 1
            tL.Text = pCfg.Title or "Paragraph"
            tL.TextColor3 = Color3.fromRGB(255, 255, 255)
            tL.TextXAlignment = Enum.TextXAlignment.Left
            tL.Font = Enum.Font.SourceSansBold
            tL.TextSize = 14
            tL.Parent = pFrame
            
            local cL = Instance.new("TextLabel")
            cL.Size = UDim2.new(1, -12, 0, 24)
            cL.Position = UDim2.new(0, 6, 0, 22)
            cL.BackgroundTransparency = 1
            cL.Text = pCfg.Content or ""
            cL.TextColor3 = Color3.fromRGB(170, 170, 170)
            cL.TextXAlignment = Enum.TextXAlignment.Left
            cL.TextWrapped = true
            cL.Font = Enum.Font.SourceSans
            cL.TextSize = 12
            cL.Parent = pFrame
            
            local Element = {}
            function Element:SetText(txt)
                cL.Text = txt
            end
            function Element:SetVisible(bool)
                pFrame.Visible = bool
            end
            return Element
        end
        
        function Tab:AddButton(bCfg)
            bCfg = bCfg or {}
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 32)
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
            btn.BorderSizePixel = 0
            btn.Text = bCfg.Title or "Button"
            btn.TextColor3 = Color3.fromRGB(240, 240, 240)
            btn.Font = Enum.Font.SourceSans
            btn.TextSize = 14
            btn.Parent = page
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = btn
            
            local cb = bCfg.Callback or function() end
            btn.MouseButton1Click:Connect(cb)
            
            local Element = {}
            function Element:SetText(txt)
                btn.Text = txt
            end
            function Element:SetVisible(bool)
                btn.Visible = bool
            end
            return Element
        end
        
        function Tab:AddToggle(tCfg)
            tCfg = tCfg or {}
            local flag = tCfg.Flag or tCfg.Title or "Toggle"
            local state = tCfg.Default or false
            
            Library.Options[flag] = { Value = state }
            local optRef = Library.Options[flag]
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 32)
            frame.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
            frame.BorderSizePixel = 0
            frame.Parent = page
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = frame
            
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -50, 1, 0)
            lbl.Position = UDim2.new(0, 10, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = tCfg.Title or "Toggle"
            lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Font = Enum.Font.SourceSans
            lbl.TextSize = 14
            lbl.Parent = frame
            
            local box = Instance.new("Frame")
            box.Size = UDim2.new(0, 20, 0, 20)
            box.Position = UDim2.new(1, -30, 0.5, -10)
            box.BackgroundColor3 = state and Color3.fromRGB(60, 130, 240) or Color3.fromRGB(50, 50, 58)
            box.BorderSizePixel = 0
            box.Parent = frame
            
            local boxCorner = Instance.new("UICorner")
            boxCorner.CornerRadius = UDim.new(0, 4)
            boxCorner.Parent = box
            
            local changedCallbacks = {}
            local function updateState(v)
                optRef.Value = v
                box.BackgroundColor3 = v and Color3.fromRGB(60, 130, 240) or Color3.fromRGB(50, 50, 58)
                for _, cb in ipairs(changedCallbacks) do
                    cb(v)
                end
                if tCfg.Callback then tCfg.Callback(v) end
            end
            
            local triggerBtn = Instance.new("TextButton")
            triggerBtn.Size = UDim2.new(1, 0, 1, 0)
            triggerBtn.BackgroundTransparency = 1
            triggerBtn.Text = ""
            triggerBtn.Parent = frame
            
            triggerBtn.MouseButton1Click:Connect(function()
                updateState(not optRef.Value)
            end)
            
            local Element = {}
            function Element:SetValue(v)
                updateState(v)
            end
            function Element:OnChanged(cb)
                table.insert(changedCallbacks, cb)
            end
            function Element:SetVisible(bool)
                frame.Visible = bool
            end
            function Element:SetText(txt)
                lbl.Text = txt
            end
            return Element
        end
        
        function Tab:AddSlider(sCfg)
            sCfg = sCfg or {}
            local flag = sCfg.Flag or sCfg.Title or "Slider"
            local min = sCfg.Min or 0
            local max = sCfg.Max or 100
            local default = sCfg.Default or min
            
            Library.Options[flag] = { Value = default }
            local optRef = Library.Options[flag]
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 45)
            frame.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
            frame.BorderSizePixel = 0
            frame.Parent = page
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = frame
            
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.6, 0, 0, 20)
            lbl.Position = UDim2.new(0, 10, 0, 4)
            lbl.BackgroundTransparency = 1
            lbl.Text = sCfg.Title or "Slider"
            lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Font = Enum.Font.SourceSans
            lbl.TextSize = 14
            lbl.Parent = frame
            
            local valLbl = Instance.new("TextLabel")
            valLbl.Size = UDim2.new(0.3, 0, 0, 20)
            valLbl.Position = UDim2.new(0.7, -10, 0, 4)
            valLbl.BackgroundTransparency = 1
            valLbl.Text = tostring(default)
            valLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
            valLbl.TextXAlignment = Enum.TextXAlignment.Right
            valLbl.Font = Enum.Font.SourceSans
            valLbl.TextSize = 13
            valLbl.Parent = frame
            
            local track = Instance.new("Frame")
            track.Size = UDim2.new(1, -20, 0, 8)
            track.Position = UDim2.new(0, 10, 0, 28)
            track.BackgroundColor3 = Color3.fromRGB(50, 50, 58)
            track.BorderSizePixel = 0
            track.Parent = frame
            
            local trackCorner = Instance.new("UICorner")
            trackCorner.CornerRadius = UDim.new(0, 4)
            trackCorner.Parent = track
            
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(60, 130, 240)
            fill.BorderSizePixel = 0
            fill.Parent = track
            
            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(0, 4)
            fillCorner.Parent = fill
            
            local changedCallbacks = {}
            local draggingSlider = false
            
            local function updateVal(v)
                v = math.clamp(v, min, max)
                optRef.Value = v
                valLbl.Text = tostring(v)
                fill.Size = UDim2.new((v - min) / (max - min), 0, 1, 0)
                for _, cb in ipairs(changedCallbacks) do cb(v) end
                if sCfg.Callback then sCfg.Callback(v) end
            end
            
            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSlider = true
                    local pct = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                    local val = math.floor(min + (max - min) * pct)
                    updateVal(val)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSlider = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local pct = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                    local val = math.floor(min + (max - min) * pct)
                    updateVal(val)
                end
            end)
            
            local Element = {}
            function Element:SetValue(v) updateVal(v) end
            function Element:OnChanged(cb) table.insert(changedCallbacks, cb) end
            function Element:SetVisible(bool) frame.Visible = bool end
            function Element:SetText(txt) lbl.Text = txt end
            return Element
        end
        
        function Tab:AddDropdown(dCfg)
            dCfg = dCfg or {}
            local flag = dCfg.Flag or dCfg.Title or "Dropdown"
            local list = dCfg.Values or {}
            local current = dCfg.Default or list[1] or ""
            
            Library.Options[flag] = { Value = current }
            local optRef = Library.Options[flag]
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 36)
            frame.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
            frame.BorderSizePixel = 0
            frame.ClipsDescendants = true
            frame.Parent = page
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = frame
            
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.5, 0, 0, 36)
            lbl.Position = UDim2.new(0, 10, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = dCfg.Title or "Dropdown"
            lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Font = Enum.Font.SourceSans
            lbl.TextSize = 14
            lbl.Parent = frame
            
            local selectedLbl = Instance.new("TextLabel")
            selectedLbl.Size = UDim2.new(0.4, 0, 0, 36)
            selectedLbl.Position = UDim2.new(0.6, -10, 0, 0)
            selectedLbl.BackgroundTransparency = 1
            selectedLbl.Text = tostring(current)
            selectedLbl.TextColor3 = Color3.fromRGB(160, 160, 160)
            selectedLbl.TextXAlignment = Enum.TextXAlignment.Right
            selectedLbl.Font = Enum.Font.SourceSans
            selectedLbl.TextSize = 13
            selectedLbl.Parent = frame
            
            local dropdownHolder = Instance.new("Frame")
            dropdownHolder.Size = UDim2.new(1, -20, 0, 0)
            dropdownHolder.Position = UDim2.new(0, 10, 0, 36)
            dropdownHolder.BackgroundTransparency = 1
            dropdownHolder.Parent = frame
            
            local dropLayout = Instance.new("UIListLayout")
            dropLayout.SortOrder = Enum.SortOrder.LayoutOrder
            dropLayout.Padding = UDim.new(0, 2)
            dropLayout.Parent = dropdownHolder
            
            local isOpen = false
            local changedCallbacks = {}
            
            local function selectVal(v)
                optRef.Value = v
                selectedLbl.Text = tostring(v)
                for _, cb in ipairs(changedCallbacks) do cb(v) end
                if dCfg.Callback then dCfg.Callback(v) end
            end
            
            local function rebuildList(items)
                for _, child in ipairs(dropdownHolder:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end
                for _, item in ipairs(items) do
                    local iBtn = Instance.new("TextButton")
                    iBtn.Size = UDim2.new(1, 0, 0, 24)
                    iBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
                    iBtn.BorderSizePixel = 0
                    iBtn.Text = tostring(item)
                    iBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                    iBtn.Font = Enum.Font.SourceSans
                    iBtn.TextSize = 13
                    iBtn.Parent = dropdownHolder
                    
                    local ic = Instance.new("UICorner")
                    ic.CornerRadius = UDim.new(0, 4)
                    ic.Parent = iBtn
                    
                    iBtn.MouseButton1Click:Connect(function()
                        selectVal(item)
                        isOpen = false
                        frame.Size = UDim2.new(1, 0, 0, 36)
                    end)
                end
            end
            rebuildList(list)
            
            local toggleBtn = Instance.new("TextButton")
            toggleBtn.Size = UDim2.new(1, 0, 0, 36)
            toggleBtn.BackgroundTransparency = 1
            toggleBtn.Text = ""
            toggleBtn.Parent = frame
            
            toggleBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    local totalH = #list * 26
                    frame.Size = UDim2.new(1, 0, 0, 40 + totalH)
                    dropdownHolder.Size = UDim2.new(1, -20, 0, totalH)
                else
                    frame.Size = UDim2.new(1, 0, 0, 36)
                end
            end)
            
            local Element = {}
            function Element:SetValue(v) selectVal(v) end
            function Element:OnChanged(cb) table.insert(changedCallbacks, cb) end
            function Element:SetVisible(bool) frame.Visible = bool end
            function Element:SetText(txt) lbl.Text = txt end
            function Element:Refresh(newList, preserve)
                list = newList or {}
                rebuildList(list)
                if not preserve then
                    selectVal(list[1] or "")
                end
            end
            return Element
        end
        
        function Tab:AddKeybind(kCfg)
            kCfg = kCfg or {}
            local flag = kCfg.Flag or kCfg.Title or "Keybind"
            local defaultKey = kCfg.Default or Enum.KeyCode.E
            
            Library.Options[flag] = { Value = defaultKey }
            local optRef = Library.Options[flag]
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 32)
            frame.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
            frame.BorderSizePixel = 0
            frame.Parent = page
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = frame
            
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.6, 0, 1, 0)
            lbl.Position = UDim2.new(0, 10, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = kCfg.Title or "Keybind"
            lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Font = Enum.Font.SourceSans
            lbl.TextSize = 14
            lbl.Parent = frame
            
            local kBtn = Instance.new("TextButton")
            kBtn.Size = UDim2.new(0, 70, 0, 22)
            kBtn.Position = UDim2.new(1, -80, 0.5, -11)
            kBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
            kBtn.BorderSizePixel = 0
            kBtn.Text = defaultKey.Name or "None"
            kBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
            kBtn.Font = Enum.Font.SourceSans
            kBtn.TextSize = 13
            kBtn.Parent = frame
            
            local kCorner = Instance.new("UICorner")
            kCorner.CornerRadius = UDim.new(0, 4)
            kCorner.Parent = kBtn
            
            local binding = false
            local changedCallbacks = {}
            
            kBtn.MouseButton1Click:Connect(function()
                binding = true
                kBtn.Text = "..."
            end)
            
            UserInputService.InputBegan:Connect(function(input, gpe)
                if binding and input.UserInputType == Enum.UserInputType.Keyboard then
                    binding = false
                    optRef.Value = input.KeyCode
                    kBtn.Text = input.KeyCode.Name
                    for _, cb in ipairs(changedCallbacks) do cb(input.KeyCode) end
                    if kCfg.Callback then kCfg.Callback(input.KeyCode) end
                end
            end)
            
            local Element = {}
            function Element:SetValue(key)
                optRef.Value = key
                kBtn.Text = key.Name
            end
            function Element:OnChanged(cb) table.insert(changedCallbacks, cb) end
            function Element:SetVisible(bool) frame.Visible = bool end
            function Element:SetText(txt) lbl.Text = txt end
            return Element
        end
        
        function Tab:AddInput(iCfg)
            iCfg = iCfg or {}
            local flag = iCfg.Flag or iCfg.Title or "Input"
            local defaultText = iCfg.Default or ""
            
            Library.Options[flag] = { Value = defaultText }
            local optRef = Library.Options[flag]
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 32)
            frame.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
            frame.BorderSizePixel = 0
            frame.Parent = page
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = frame
            
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.5, 0, 1, 0)
            lbl.Position = UDim2.new(0, 10, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = iCfg.Title or "Input"
            lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Font = Enum.Font.SourceSans
            lbl.TextSize = 14
            lbl.Parent = frame
            
            local box = Instance.new("TextBox")
            box.Size = UDim2.new(0.4, 0, 0, 22)
            box.Position = UDim2.new(0.6, -10, 0.5, -11)
            box.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
            box.BorderSizePixel = 0
            box.Text = defaultText
            box.PlaceholderText = iCfg.Placeholder or "Type here..."
            box.TextColor3 = Color3.fromRGB(240, 240, 240)
            box.Font = Enum.Font.SourceSans
            box.TextSize = 13
            box.Parent = frame
            
            local bCorner = Instance.new("UICorner")
            bCorner.CornerRadius = UDim.new(0, 4)
            bCorner.Parent = box
            
            local changedCallbacks = {}
            
            box.FocusLost:Connect(function()
                optRef.Value = box.Text
                for _, cb in ipairs(changedCallbacks) do cb(box.Text) end
                if iCfg.Callback then iCfg.Callback(box.Text) end
            end)
            
            local Element = {}
            function Element:SetValue(val)
                box.Text = val
                optRef.Value = val
            end
            function Element:OnChanged(cb) table.insert(changedCallbacks, cb) end
            function Element:SetVisible(bool) frame.Visible = bool end
            function Element:SetText(txt) lbl.Text = txt end
            return Element
        end
        
        function Tab:AddColorpicker(cCfg)
            cCfg = cCfg or {}
            local flag = cCfg.Flag or cCfg.Title or "Colorpicker"
            local defaultColor = cCfg.Default or Color3.fromRGB(255, 255, 255)
            
            Library.Options[flag] = { Value = defaultColor }
            local optRef = Library.Options[flag]
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 32)
            frame.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
            frame.BorderSizePixel = 0
            frame.Parent = page
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = frame
            
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.7, 0, 1, 0)
            lbl.Position = UDim2.new(0, 10, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = cCfg.Title or "Colorpicker"
            lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Font = Enum.Font.SourceSans
            lbl.TextSize = 14
            lbl.Parent = frame
            
            local colorBox = Instance.new("Frame")
            colorBox.Size = UDim2.new(0, 26, 0, 18)
            colorBox.Position = UDim2.new(1, -36, 0.5, -9)
            colorBox.BackgroundColor3 = defaultColor
            colorBox.BorderSizePixel = 0
            colorBox.Parent = frame
            
            local cbCorner = Instance.new("UICorner")
            cbCorner.CornerRadius = UDim.new(0, 4)
            cbCorner.Parent = colorBox
            
            local changedCallbacks = {}
            
            local Element = {}
            function Element:SetValue(col)
                optRef.Value = col
                colorBox.BackgroundColor3 = col
                for _, cb in ipairs(changedCallbacks) do cb(col) end
                if cCfg.Callback then cCfg.Callback(col) end
            end
            function Element:OnChanged(cb) table.insert(changedCallbacks, cb) end
            function Element:SetVisible(bool) frame.Visible = bool end
            function Element:SetText(txt) lbl.Text = txt end
            return Element
        end
        
        table.insert(Window.Tabs, Tab)
        if #Window.Tabs == 1 then
            Window:SelectTab(Tab)
        end
        
        return Tab
    end
    
    return Window
end

return Library
