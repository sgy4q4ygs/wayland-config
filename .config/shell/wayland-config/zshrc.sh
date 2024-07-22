_dotnet()
{
    local completions=("$(dotnet complete "$words")")
    if [ -z "$completions" ]; then
        _arguments '*::arguments: _normal'
        return
    fi
    local -a completionArray
    completionArray=("${(@ps:\n:)completions}") # Split by newline
    _values 'dotnet subcommands' $completionArray
}

compdef _dotnet dotnet
