{
    directory => "dotfiles",
    files => [qw(
        bin
        bin.d/gittools
        .vim
        .vimrc
        .gvimrc
        .vimperator
        .vimperatorrc
        .bash_profile
        .bashrc
        .screenrc
        .inputrc
        .zshrc
        .zshenv
        .zsh
        .skel
        .module-starter
        .w3m/keymap
        .Xmodmap
        .shrc.common
        .shrc.cygwin
        .shrc.start-screen
        .env.common
        .tmux.conf
        .tmux
        .uim
        .uim.d/customs
    )],
    os_files => {map {
        # MS Windows-specific filenames.
        $_ => {
            '.vimperator' => 'vimperator',
            '.vimperatorrc' => '_vimperatorrc',
            '.vim' => 'vimfiles',
        }
    } qw(MSWin32 cygwin)},
    ignore_files => [qw(
        .vim/backup
        .vim/.netrwhist
        .vim/.VimballRecord
        .vim/info
        .vim/record
        .vim/sessions
        .vim/swap
        .vimperator/info
    )],
}
