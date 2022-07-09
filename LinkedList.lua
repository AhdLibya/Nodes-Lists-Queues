--[[
    
    Class: 
        List
    Author : 
        @Ahdlibya
    Date: 
        june , 12 , 2022
    
]]


export type Node = {
    value : any ,
    index : number,
    next  : Node?,
    Head  : Node?
}

export type void = ( nil ) -> ()

export type List = { Node }

local Node = {}
Node.__index = Node


function Node.new(value : any , index : number, next : Node?) : Node
    local self = setmetatable({}, Node)
    self.index = index
    self.value = value
    self.next  = next
    return self
end


function Node:IsA(_node : Node)
    return typeof(_node) == "table" and getmetatable(_node) == Node
end

function Node:GetElement(Head : Node , index : number)
    assert(index > 0 , "Enter Valid Number")
    assert(typeof(index) == "number" , 'expcted number got ( '..typeof(index)..' )')
    local _head = Head
    local i = 1
    while i < index and _head ~= nil do
        _head = _head.next
        i+=1
    end
    return _head
end


function Node:Debug(Head : Node)
    local _head = Head
    while _head ~= nil do
        warn(_head.value)
        _head = _head.next
        task.wait()
    end
end


function Node:GetLastElement(Head : Node)
    local _head = Head
    while _head.next ~= nil do
        _head = _head.next
        task.wait()
    end
    return _head
end


function Node:append_List( value : any , Head : Node ) : Node | nil
    local node = Node.new(value)
    if Head == nil then
        Head = node
    else
        self:GetLastElement(Head).next = node
        node.Head = Head
    end
    return Head
end


function Node:Destroy() : void
    for key, _ in pairs(self) do
        self[key] = nil
    end
    self = nil
end



local List = {}
List.__index = List


--[[
    @Cuntroct New List \
    @Expline \
    @param (Head) -> [Node]  --Optional
    @return List object
    ```lua  
        local List = require(THIS_MODULE_PATH).List
        local list = List.new()
        local node = list:CreateNode('SOMEDATA')

        list:map(function(value)  -- value => "SOMEDATA"
            doSomethingWithValue(value)
        end)

        list:Clear() -- Clean up the list
    ```
]]
function List.new(head : Node) 
    local self = setmetatable({
        _list = {};
        Head = head or nil
    }, List)
    return self
end


--[[

    @Cuntroct New Node and set the head automathicly\
    @param take a value of any type ('string' , number ,table ,etc..)\
    @return Node
    ```lua
        local List = require(THIS_MODULE_PATH).List
        local Part = Instance.new('Part')
        local list = List.new()

        local node1 = list:CreateNode('SomeString')
        local node2 = list:CreateNode(585)
        local node3 = list:CreateNode(Part)

        --The list will be sorted by this order :
            --{node1 , node2 , node3}
        print(node1.value) -- result -> 'SomeString'
        print(node2.value) -- result -> 585
        print(node3.value) -- result -> Part
    ```
]]
function List:CreateNode(value) : Node
    if #self._list == 0 or self.Head == nil then
        local node = Node.new(value , #self._list+1)
        self.Head = node
        self:_add(node)
        return node
    else
        local node = Node.new(value, #self._list+1)
        self:_add(node)
        for _ , _node : Node in ipairs(self._list) do
            if _node.next == nil then
                _node.next = node
                break
            end
        end
        return node
    end
end


function List:_add(_node : Node)
    assert(Node:IsA(_node) , "You must Provid This function with node object")
    self._list[#self._list+1] = _node
end

--[[
    ```lua
        local List = require(THIS_MODULE_PATH).List
        local Part = Instance.new('Part')
        local list = List.new()

        local node1 = list:CreateNode('SomeString')
        local node2 = list:CreateNode(585)
        local node3 = list:CreateNode(Part)

        local Item_Removed = list:Remove("SomeString")
        print(Item_Removed) --result -> true || false
        list:Debug() --result -> 585 , Part
    ```
    @return boolean
]]
function List:Remove(value)
    for index, node : Node in ipairs(self._list) do
        --print(node.value)
        if Node:IsA(node) and node.value == value then
            if node == self.Head then
                self.Head = nil
                self.Head = node.next
            end
            print('This The node Value '..node.value)
            print("This The Provide Value " .. value)
            node:Destroy()
            table.remove(self._list , index)
            return true
        end
    end
    return false
end

--[[
    ```lua
        local List = require(THIS_MODULE_PATH).List
        local Part = Instance.new('Part')
        local list = List.new()

        local node1 = list:CreateNode('SomeString')
        local node2 = list:CreateNode(585)
        local node3 = list:CreateNode(Part)

        list:remove(1)
        list:Debug() --result -> 585 , Part
    ```
    @return nil
]]
function List:remove(index : number)
    assert(typeof(index) == "number" , "Number Expxted Got ".. typeof(index))
    for _, node : Node in ipairs(self._list) do
        if Node:IsA(node) and node.index == index then
            if node == self.Head then
                self.Head = nil
                self.Head = node.next
            end
            node:Destroy()
            table.remove(self._list , index)
            break
        end
    end
end

--[[
    
    ```lua
        local List = require(THIS_MODULE_PATH).List
        local Part = Instance.new('Part')
        local list = List.new()

        local node1 = list:CreateNode('SomeString')
        local node2 = list:CreateNode(585)
        local node3 = list:CreateNode(Part)

        list:GetNode(3) -- return -> node3
        
    ```
    @return Node
]]
function List:GetNode(index) : Node
    assert(typeof(index) == "number" , "Number Expxted Got ".. typeof(index))
    return Node:GetElement(self.Head , index)
end

--[[
    @return nil
    ```lua
        local List = require(THIS_MODULE_PATH).List
        local Part = Instance.new('Part')
        local list = List.new()

        local node1 = list:CreateNode('SomeString')
        local node2 = list:CreateNode(585)
        local node3 = list:CreateNode(Part)

        list:map(function(value)
            print(value) -- result -> 'SomePart' , 585 , Part
        end)
        
    ```
    
]]
function List:map(callback : (value : any) ->()) : void
    self:mapforNode(function(node : Node)
        callback(node.value)
    end)
end

--[[
    @return nil
    ```lua
    local List = require(THIS_MODULE_PATH).List
    local Part = Instance.new('Part')
    local list = List.new()

    local node1 = list:CreateNode('SomeString')
    local node2 = list:CreateNode(585)
    local node3 = list:CreateNode(Part)

    list:mapforNode(function(node)
        print(node.value) -- result -> 'SomePart' , 585 , Part
    end)
        
    ```
    
]]
function List:mapforNode(callback : (node : Node) ->() ) : void
    for _ , node:Node in ipairs(self._list) do
        callback(node)
    end
end

--[[
    @Return  all elements from the list as a tuple. \
    @warn This function will Clear the list
    ```lua
    local List = require(THIS_MODULE_PATH).List
    local Part = Instance.new('Part')
    local list = List.new()

    local node1 = list:CreateNode('SomeString')
    local node2 = list:CreateNode(585)
    local node3 = list:CreateNode(Part)

    -- 'SomeString'  --585      --Part
    local mystring , mynumber , myPart = list:unpack()
        
    ```
    
]]
function List.unpack(self)
    local t = {}
    self:map(function(value)
        table.insert(t , value)
    end)
    self:Clear()
    return table.unpack(t)
end


--[[
    @return Node
    ```lua
    local List = require(THIS_MODULE_PATH).List
    local list = List.new()

    local Part = Instance.new('Part')
    local PackedNod = list:pack('SomeString', 585 , Part) -- Type [Node]

    list:Debug() --result ->{'SomeString', 585 , Part}
    ```
]]
function List.pacK(self, ... : any)
    -- body
    local args = {...}
    local t    = {}
    for _, value in pairs(args) do
        table.insert( t , value )
    end
    return self:CreateNode(t)
end


function List:Clone() 
    local clone = List.new()
    self:map(function(value)
        clone:CreateNode(value)
    end)
    return clone
end

--[[
    Display all the values in the list to the output

    ```lua
    local List = require(THIS_MODULE_PATH).List
    local Part = Instance.new('Part')
    local list = List.new()

    local node1 = list:CreateNode('SomeString')
    local node2 = list:CreateNode(585)
    local node3 = list:CreateNode(Part)

    list:Debug() --result -> 'SomeString' , 585 , Part
    ```
    @return nil
]]
function List:Debug()
    local Head = self.Head and self.Head.value or nil
    warn("Head : "..Head)
    self:map(function(value) 
        warn("------------------")
        warn(value)
        warn("------------------")
    end)
end

--[==[
    @warn This Method Dosn't Destroy The list but it clean all The nodes in said of it
    ```lua
    local List = require(THIS_MODULE_PATH).List
    local Part = Instance.new('Part')
    local list = List.new()

    local node1 = list:CreateNode('SomeString')
    local node2 = list:CreateNode(585)
    local node3 = list:CreateNode(Part)

    list:Clear()
    list:Debug() --result -> nil
    ```
    @Return nil
]==]
function List:Clear() : void
    for index , value in ipairs(self._list)do
        value:Destroy()
        self._list[index] = nil
    end
end


--[[
    @param List Object \
    @Return number
    ```lua
    local List = require(THIS_MODULE_PATH).List
    local Part = Instance.new('Part')
    local list = List.new()

    local node1 = list:CreateNode('SomeString')
    local node2 = list:CreateNode(585)
    local node3 = list:CreateNode(Part)

    local sizeofmylist = List.sizeof(list)

    print(sizeofmylist) -- result -> 3
    ```
]]
function List.sizeof(self : List) : number
    assert(typeof(self) == "table" and getmetatable(self) == List , 'Can not index sizeof with none List object')
    return #self._list
end


--[[
    @param nil \
    @return Boolean 
    ```lua
        local List = require(THIS_MODULE_PATH).List
        local list = List.new()

        list:IsEmpty() --result -> true

        local node1 = list:CreateNode('SomeString')

        list:IsEmpty() -- result -> false
    ```
    
]]
function List:IsEmpty() 
    return #self._list == 0
end


local Queue = {}
Queue.__index = Queue

function Queue.new()
    return setmetatable({
        _queue = List.new()
    } ,Queue)
end

function Queue:enqueue(value)
    self._queue:CreateNode(value)
end

function Queue:dequeue()
    return self._queue:Remove(self._queue.Head.value)
end

function Queue:Front()
    return self._queue.Head.value
end

function Queue:Sizeof()
    return List.sizeof(self._queue)
end

function Queue:Clear()
    self._queue:Clear()
end

function Queue:GetAll()
    local values = {}
    self._queue:map(function(value) 
        table.insert(values , value)
    end)
    return values
end

function Queue:IsEmpty()
    return self._queue:IsEmpty()
end

return { Node   = Node ; List   = List ; Queue  = Queue ; }