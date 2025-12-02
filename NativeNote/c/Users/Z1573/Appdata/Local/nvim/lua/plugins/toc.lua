-- ~/.config/nvim/lua/plugins/toc.lua

return {
	"ghassan/toc.nvim",
	-- 仅在 markdown 文件类型中加载
	ft = { "markdown" },
	opts = {
		-- 默认配置
		title = "目录", -- 目录窗口的标题
		open_keys = { "<leader>ot" }, -- 推荐的打开快捷键
		-- 其他常用配置项：
		-- start_level = 1,       -- 从哪个级别的标题开始（默认 1）
		-- end_level = 6,         -- 到哪个级别的标题结束（默认 6）
		-- auto_open = false,     -- 是否在打开 markdown 文件时自动弹出目录
	},
	keys = {
		-- 为 markdown 文件添加快捷键映射
		{
			"<leader>ot",
			function()
				require("toc").open()
			end,
			mode = "n",
			desc = "Markdown: Toggle Table of Contents (TOC)",
		},
		-- 添加一个快捷键用于在当前 buffer 插入目录
		{
			"<leader>it",
			function()
				require("toc").insert()
			end,
			mode = "n",
			desc = "Markdown: Insert Table of Contents",
		},
	},
}
