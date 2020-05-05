cd dotfiles
for file in *; do
    ln -sf dotfiles/"$file" ~/."$file"
done
