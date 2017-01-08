clean:
	stack build && stack exec generator clean

gen:
	stack build && stack exec generator build