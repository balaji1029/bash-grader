#!/usr/bin/bash

_submission_completion() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    sub_opts="combine upload total update git_init git_commit git_log git_checkout git_config stats student grade train"
    bash_opts="submission.sh"

    if [[ "$prev" == "bash" ]]; then
        COMPREPLY=( $(compgen -W "${bash_opts}" -- ${cur}) )
        return 0;
    elif [[ "$prev" == "submission.sh" ]] || [[ "$prev" == "./submission.sh" ]]; then
        COMPREPLY=( $(compgen -W "${sub_opts}" -- ${cur}) )
        return 0;
    elif [[ "$prev" == "-q" ]] || [[ "$prev" == "--quiz" ]] || [[ "$prev" == "update" ]]; then
        quizzes=$(ls | grep -E ".*\.csv" | grep -v "^temp\.csv$" | grep -v "^main\.csv$" | grep -v "^rubrics\.csv$" | grep -v "^graded\.csv$" | sed 's/\.csv//g' | tr '\n' ' ')
        COMPREPLY=( $(compgen -W "${quizzes}" -- ${cur}) )
        return 0;
    elif [[ "$prev" == "-w" ]]; then
        flag="-q"
        COMPREPLY=( $(compgen -W "${flag}" -- ${cur}) )
        return 0;
    # elif [[ "$prev" == "-s" ]]; then
    #     students_names=$(cut -d, -f2 main.csv | tail -n +2)
    #     echo "$students_names"
    #     COMPREPLY=( $(compgen -W "${students_names}" -- ${cur}) )
    elif [[ "$prev" == "stats" ]]; then
        flags="-b -q -w"
        COMPREPLY=( $(compgen -W "${flags}" -- ${cur}) )
        return 0;
    elif [[ "$prev" == "git_config" ]]; then
        git_options="user.name user.email"
        COMPREPLY=( $(compgen -W "${git_options}" -- ${cur}) )
        return 0;
    elif [[ "$prev" == "git_commit" ]]; then
        git_commit_options="-m"
        COMPREPLY=( $(compgen -W "${git_commit_options}" -- ${cur}) )
        return 0;
    elif [[ "$prev" == "git_checkout" ]]; then
        if [[ -e $(cat .mygit/dest) ]]; then
            git_checkout_options=$(cut -d, -f2 $(realpath $(cat .mygit/dest))/.git_log)
        else
            git_checkout_options=""
        fi
        COMPREPLY=( $(compgen -W "${git_checkout_options}" -- ${cur}) )
        return 0;
    elif [[ "$prev" == "student" ]]; then
        options="-r -n -w"
        COMPREPLY=( $(compgen -W "$(options)" -- ${cur}) )
        return 0;
    elif [[ "$prev" == "git_log" ]]; then
        options="--oneline"
        COMREPLY=( $(compgen -W "$options" -- ${curn}) )
        return 0;
    fi

    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}

complete -F _submission_completion bash
