tutorialOpen = true
currentIndex = 1

function setCategoriesColor()
    for x = 1, #tutorialsIndex do
        indexList:getChildById("index"..x):setColor(categoriesColor)
    end
end

function init()

    tutorialWindow = g_ui.loadUI('tutorial', rootWidget)
    tutorialWindow:hide()

    assignWindow = tutorialWindow:getChildById('tutorialImg')
    indexList = tutorialWindow:getChildById('indexList')


    for x = 1, #tutorialsIndex do
        local label = g_ui.createWidget('TutorialLabel', indexList)

        label:setId("index"..x)
        label.index = x
        label:setText(tr(tutorialsIndex[x]))
        label:setColor(categoriesColor)

        for y = 1, #tutorialsInfo[x] do
            local currentTutorial = tutorialsInfo[x][y]
            local labelTree = g_ui.createWidget('TutorialLabel', indexList)

            labelTree.img = currentTutorial.img
            labelTree:setId("index"..x.."labelTree"..y)
            labelTree.description = currentTutorial.text
            labelTree:setText("    "..currentTutorial.name)
            labelTree:setVisible(false)
            labelTree.index = x
            labelTree.isTutorial = true
        end
    end

    connect(indexList, {
        onChildFocusChange = changeFocusIndexList
    })
end

function changeFocusIndexList(self, focusedChild)
    if focusedChild == nil then return end


    for x = 1, #tutorialsIndex do
        if x == focusedChild.index then
            for y = 1, #tutorialsInfo[x] do
                if focusedChild.isOpen then
                    indexList:getChildById("index"..x.."labelTree"..y):setVisible(false)
                else
                    indexList:getChildById("index"..x.."labelTree"..y):setVisible(true)
                end
            end
            break
        end
    end

    if focusedChild.isTutorial then
        local tutorialText = tutorialWindow:getChildById('scrollablePainel'):getChildById('tutorialText')
        tutorialText:setText(focusedChild.description)
    else
        tutorialWindow:getChildById('scrollablePainel'):getChildById('tutorialText'):setText(msgStart)
        if focusedChild.isOpen then focusedChild.isOpen = false else focusedChild.isOpen = true end

        if focusedChild.isOpen then
            indexList:focusChild(indexList:getChildById("index"..focusedChild.index.."labelTree1"))
        else
            indexList:focusChild(nil)
        end
    end

    setCategoriesColor()
end

function changeFocusTutorialList(self, focusedChild)
    if focusedChild == nil then return end

    local tutorialText = tutorialWindow:getChildById('scrollablePainel'):getChildById('tutorialText')
    tutorialText:setText(focusedChild.description)
end

function destroyAll()
    tutorialWindow:destroy()
    --tutorialButton:destroy() 
end


function terminate()
    destroyAll()
end

function onOpenTutorial()
    tutorialWindow:show()
    tutorialWindow:raise()
    tutorialWindow:focus()

    indexList:focusChild(nil)
    tutorialWindow:getChildById('scrollablePainel'):getChildById('tutorialText'):setText(msgStart)
    tutorialOpen = true
    currentIndex = 0

    setCategoriesColor()
end

function onClickTutorial()
    if not tutorialOpen then
        onOpenTutorial()
    else
        tutorialOpen = false
        tutorialWindow:hide()
    end
end