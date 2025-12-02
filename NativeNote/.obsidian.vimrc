

" --- 基本映射 ---
" 映射 jj 为 Esc 退出插入模式
imap jk <Esc>

" --- 移动优化 ---
" 在长文本（折行）中移动时，按物理行移动而不是逻辑行
nmap J 5j
nmap K 5k

" --- 系统剪贴板 ---
" 现在的 Obsidian 版本通常默认支持剪贴板，但如果不好用可以加上
set clipboard=unnamed

" --- 验证是否生效 ---
" 如果生效，你在普通模式按 H 应该会跳到行首
nmap H ^
nmap L $

" --- 1. 设置 Leader 为空格 ---
" 重要：先解除空格键默认的移动功能，否则它不会等待后续按键
unmap <Space>

" --- 2. 定义快捷键 ---
" 说明：
" o = 向下插入一行并进入插入模式
" O = 向上插入一行并进入插入模式
" <Esc> = 立即退出插入模式，回到 Normal 模式

" <Space> + j : 向下插入空行并保持 Normal 模式
nmap <Space>j o<Esc>

" <Space> + k : 向上插入空行并保持 Normal 模式
nmap <Space>k O<Esc>

" 1. 定义一个 Ex 命令，用于全局搜索
" obcommand 是 Obsidian Vimrc 插件提供的，用于调用 Obsidian 内部命令
exmap globalsearch obcommand global-search:open

" 2. 映射 <leader>s 到这个 Ex 命令
" 这样，在 Normal 模式下按 [空格] + [s] 就可以打开全局搜索面板
nmap <leader>s :globalsearch<CR>


" 3. 映射 <leader>f 到快速文件切换器 (Quick Switcher)
" 这样按 [空格] + [f] 就可以快速跳转到其他文件
exmap quickfile obcommand switcher:open
nmap <leader>f :quickfile<CR>
