Stack={}
Stack._stack=[]
Stack.push=function(item)
self._stack.push(@item)
end function
Stack.pop=function()
return self._stack.pop
end function
Stack.peek=function()
return self._stack[self._stack.len-1]
end function
Stack.isEmpty=function()
return self._stack.len==0
end function
Stack.New=function()
result=new Stack
result._stack=[]
return result
end function
__scope__=function()
locals.testStack=Stack.New
testStack.push({"name":"root","tests":[],"errors":[],"beforeEach":null,"afterEach":null,"root":true,"mocks":[],"mockCalls":[]})
checkIfTestHasErrors=function(test)
if test.errors.len>0 then
return true
end if
for subtest in test.tests
if checkIfTestHasErrors(subtest) then
return true
end if
end for
return false
end function
displayTestResults=function(depth=0,test)
if test==null then
test=testStack._stack[0]
end if
if not test.root then
if not checkIfTestHasErrors(test) then
print("  "*depth+"✓ "+test.name)
else
print("  "*depth+"✗ "+test.name)
for error in test.errors
print("  "*(depth+1)+error)
end for
end if
end if
for subtest in test.tests
displayTestResults(depth+1,subtest)
end for
end function
test=function(name,callback)
test={"name":name,"tests":[],"errors":[],"beforeEach":null,"afterEach":null,"root":false,"mocks":[],"mockCalls":[]}
testStack.peek.beforeEach
if not testStack.isEmpty then
testStack.peek.tests.push(test)
end if
testStack.push(test)
callback
testStack.pop
testStack.peek.afterEach
if testStack._stack.len==1 then
displayTestResults
testStack.pop
testStack.push({"name":"root","tests":[],"errors":[],"beforeEach":null,"afterEach":null,"root":true,"mocks":[],"mockCalls":[]})
end if
end function
Checker={}
Checker.value=null
Checker._not=false
Checker.onError=function(error)
exit("onError not implemented")
end function
Checker.n=function()
self._not=true
return self
end function
Checker.toBe=function(value)
if self._not then
if self.value==value then
self.onError("Expected "+self.value+" not to be "+value)
end if
else
if self.value!=value then
self.onError("Expected "+self.value+" to be "+value)
end if
end if
self._not=false
return self
end function
Checker.toBeCloseTo=function(value,precision)
dif=abs(self.value-value)
if str(dif).split(".").hasIndex(1) then
dif=round(dif,str(precision).split(".")[1].len+1)
end if
if self._not then
if dif<=precision then
self.onError("Expected "+self.value+" not to be close to "+value+" with precision "+precision)
end if
else
if dif>precision then
self.onError("Expected "+self.value+" to be close to "+value+" with precision "+precision)
end if
end if
self._not=false
return self
end function
Checker.toBeDefined=function()
if self._not then
if self.value!=null then
self.onError("Expected "+self.value+" not to be defined")
end if
else
if self.value==null then
self.onError("Expected "+self.value+" to be defined")
end if
end if
self._not=false
return self
end function
Checker.toBeUndefined=function()
if self._not then
if self.value==null then
self.onError("Expected "+self.value+" not to be undefined")
end if
else
if self.value!=null then
self.onError("Expected "+self.value+" to be undefined")
end if
end if
self._not=false
return self
end function
Checker.toBeTruthy=function()
if self._not then
if self.value then
self.onError("Expected "+self.value+" not to be truthy")
end if
else
if not self.value then
self.onError("Expected "+self.value+" to be truthy")
end if
end if
self._not=false
return self
end function
Checker.toBeFalsy=function()
if self._not then
if not self.value then
self.onError("Expected "+self.value+" not to be falsy")
end if
else
if self.value then
self.onError("Expected "+self.value+" to be falsy")
end if
end if
self._not=false
return self
end function
Checker.toBeTypeOf=function(type)
if self._not then
if typeof(self.value)==type then
self.onError("Expected "+self.value+" not to be type of "+type)
end if
else
if typeof(self.value)!=type then
self.onError("Expected "+self.value+" to be type of "+type)
end if
end if
self._not=false
return self
end function
Checker.toBeInstanceOf=function(type)
if self._not then
if self.value isa type then
self.onError("Expected "+self.value+" not to be instance of "+type)
end if
else
if not self.value isa type then
self.onError("Expected "+self.value+" to be instance of "+type)
end if
end if
self._not=false
return self
end function
Checker.toBeGreaterThan=function(value)
if self._not then
if self.value>value then
self.onError("Expected "+self.value+" not to be greater than "+value)
end if
else
if self.value<=value then
self.onError("Expected "+self.value+" to be greater than "+value)
end if
end if
self._not=false
return self
end function
Checker.toBeGreaterThanOrEqual=function(value)
if self._not then
if self.value>=value then
self.onError("Expected "+self.value+" not to be greater than or equal "+value)
end if
else
if self.value<value then
self.onError("Expected "+self.value+" to be greater than or equal "+value)
end if
end if
self._not=false
return self
end function
Checker.toBeLessThan=function(value)
if self._not then
if self.value<value then
self.onError("Expected "+self.value+" not to be less than "+value)
end if
else
if self.value>=value then
self.onError("Expected "+self.value+" to be less than "+value)
end if
end if
self._not=false
return self
end function
Checker.toBeLessThanOrEqual=function(value)
if self._not then
if self.value<=value then
self.onError("Expected "+self.value+" not to be less than or equal "+value)
end if
else
if self.value>value then
self.onError("Expected "+self.value+" to be less than or equal "+value)
end if
end if
self._not=false
return self
end function
Checker.toContain=function(value)
if self._not then
if self.value.indexOf(@value)!=null then
self.onError("Expected "+self.value+" not to contain "+value)
end if
else
if self.value.indexOf(@value)==null then
self.onError("Expected "+self.value+" to contain "+value)
end if
end if
self._not=false
return self
end function
Checker.toHaveLength=function(length)
if self._not then
if self.value.len==length then
self.onError("Expected "+self.value+" not to have length "+length)
end if
else
if self.value.len!=length then
self.onError("Expected "+self.value+" to have length "+length)
end if
end if
self._not=false
return self
end function
Checker.toHaveProperty=function(property)
if self._not then
if self.value.hasIndex(@property) then
self.onError("Expected "+self.value+" not to have property "+property)
end if
else
if not self.value.hasIndex(@property) then
self.onError("Expected "+self.value+" to have property "+property)
end if
end if
self._not=false
return self
end function
Checker.New=function(value)
result=new self
result.value=value
return result
end function
Expect=new Checker
Expect.onError=function(error)
testStack.peek.errors.push(error)
end function
Assert=new Checker
Assert.onError=function(error)
testStack.peek.errors.push(error)
displayTestResults
exit("")
end function
Fn={}
Fn.calls=[]
Fn.results=[]
Fn.callback=null
Fn.lastCall=function()
return self.calls[self.calls.len-1]
end function
Fn.lastResult=function()
return self.results[self.results.len-1]
end function
Fn.invocationCallOrder=function()
result=[]
i=0
for call in testStack.peek.mockCalls
if call==self then
result.push(i)
end if
i=i+1
end for
end function
Fn.wrapCallback=function(callback,argumentCount=0)
this=self
currentTest=testStack.peek
handleCall=function()
currentTest.mockCalls.push(this)
end function
if argumentCount==0 then
res=function()
handleCall
this.calls.push([])
result=callback
this.results.push(@result)
return @result
end function
else if argumentCount==1 then
res=function(a)
handleCall
this.calls.push([@a])
result=callback(@a)
this.results.push(@result)
return @result
end function
else if argumentCount==2 then
res=function(a,b)
handleCall
this.calls.push([@a,@b])
result=callback(@a,@b)
this.results.push(@result)
return @result
end function
else if argumentCount==3 then
res=function(a,b,c)
handleCall
this.calls.push([@a,@b,@c])
result=callback(@a,@b,@c)
this.results.push(@result)
return @result
end function
else if argumentCount==4 then
res=function(a,b,c,d)
handleCall
this.calls.push([@a,@b,@c,@d])
result=callback(@a,@b,@c,@d)
this.results.push(@result)
return @result
end function
else
exit("Fn.wrapCallback not implemented for "+argumentCount+" arguments")
end if
return @res
end function
Fn.reset=function()
self.calls=[]
self.results=[]
end function
Fn.New=function(callback,argumentsCount=0)
result=new Fn
testStack.peek.mocks.push(result)
result.callback=@result.wrapCallback(@callback,argumentsCount)
result.calls=[]
result.results=[]
return result
end function
Mobject={}
Mobject.object={}
Mobject.mocks={}
Mobject.addMethod=function(name,callback,argumentCount=0)
result=Fn.New(@callback,argumentCount)
self.object[name]=@result.callback
self.mocks[name]=@result
end function
Mobject.New=function(object)
result=new Mobject
result.object={}
result.object.__isa=object
result.mocks={}
return result
end function
globals.vi={}
vi.expect=function(value)
return Expect.New(@value)
end function
vi.assert=function(value)
return Assert.New(@value)
end function
vi.fn=function(callback,argumentsCount=0)
return Fn.New(@callback,argumentsCount)
end function
vi.mock=function(object)
return Mobject.New(@object)
end function
vi.test=function(name,callback)
test(name,@callback)
end function
vi.beforeEach=function(callback)
testStack.peek.beforeEach=@callback
end function
vi.afterEach=function(callback)
testStack.peek.afterEach=@callback
end function
vi.stopMocking=function()
testStack.peek.mocks=[]
testStack.peek.mockCalls=[]
end function
vi.resetMocks=function()
testStack.peek.mockCalls=[]
for mock in testStack.peek.mocks
mock.reset
end for
end function
vi.global=function()
for item in vi
key=item.key
value=@item.value
globals[key]=@value
end for
end function
end function
__scope__
globals.remove("__scope__")