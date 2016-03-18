# General

- Every line of code comes with a hidden piece of documentation.
- Don’t Message self in Objective-C init (and dealloc)
- Muti-Parameters to object
- Don’t Use Accessor Methods in Initializer Methods and dealloc
- Stick to a line-based coding style

# Whitespace

- Tabs, not spaces
- End files with a newline
- Make liberal use of vertical whitespace to divide code into logical chunks.
- Don’t leave trailing whitespace.
	* Not even leading indentation on blank lines. 

# Documentation and Organization

* Use [TomDoc](http://tomdoc.org)

- All method declarations should be documented.
- Comments should be hard-wrapped at `80` characters.
- Comments should be VVDocuemnt.
- Document whether object parameters allow nil as a value.

# Declarations

- Never declare an ivar unless you need to change its type from its declared property.
- Don’t use line breaks in method declarations.
- Prefer exposing an immutable type for a property if it being mutable is an implementation detail. This is a valid reason to declare an ivar for a property.
- Always declare memory-management semantics even on readonly properties.
- Declare properties readonly if they are only set once in -init.
- Don't use @synthesize unless the compiler requires it. Note that optional properties in protocols must be explicitly synthesized in order to exist.
- Declare properties copy if they return immutable objects and aren't ever mutated in the implementation. strong should only be used when exposing a mutable object, or an object that does not conform to <NSCopying>.
- Avoid weak properties whenever possible. A long-lived weak reference is usually a code smell that should be refactored out.
- Instance variables should be prefixed with an underscore (just like when implicitly synthesized).
- Don't put a space between an object type and the protocol it conforms to.

# Expressions

- Don't access an ivar unless you're in -init, -dealloc or a custom accessor.
- Use dot-syntax when invoking idempotent methods, including setters and class methods (like NSFileManager.defaultManager).
- Use object literals, boxed expressions, and subscripting over the older, grosser alternatives.
- Comparisons should be explicit for everything except BOOLs.
- Prefer positive comparisons to negative.
- Long form ternary operators should be wrapped in parentheses and only used for assignment and arguments.

# Naming

- Use `-`  link Resource file name.
- noun 

# Coding

- Indent using 2 spaces with Tab.
- Keep lines 100 characters or shorter. Break long statements into
  shorter ones over multiple lines.
- In Objective-C, use `#pragma mark -` to mark public, internal,
  protocol, and superclass methods.

# Commits

- Why is this change necessary?
- How does it address the issue?
- What side effects does this change have?
- Update Fix Add Improve Move
- Remove Clean Rename Format Refactor Use
- Bumping version to / Convert to
- To the discussion. issue/story/card

# Release

- Version `v` prefix
- Builds auto increase
- Bumping version to `v1.0.0`
- Tag the version: `git tag -s vA.B.C -F release-notes-file`
- Push the tag: `git push origin master --tags`
- Announce!


---- 
**Stick to a line-based coding style**

> Corollary of avoiding unrelated changes: **stick to a line-based coding style** that allows you to append, edit or remove values from lists without changing adjacent lines. Some examples:

	var one = "foo"
	  , two = "bar"
	  , three = "baz"   // Comma-first style allows us to add or remove a
	// new variable without touching other lines
	
	Ruby:
	result = make_http_request(
	  :method => 'POST',
	  :url => api_url,
	  :body => '...',   // Ruby allows us to leave a trailing comma, making it
	)                   // possible to add/remove params while not touching others