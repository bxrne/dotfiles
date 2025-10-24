#!/bin/bash

echo "🌲 Restarting applications to apply Everforest theme..."

# Kill running instances
echo "🔄 Stopping running applications..."
pkill ghostty
pkill waybar
pkill mako

# Wait a moment for processes to stop
sleep 2

# Restart applications
echo "🚀 Starting applications with new theme..."
# Start Waybar
waybar &

# Restart Mako
mako &

echo "✅ Theme applications restarted!"
echo ""
echo "📝 To complete the theme change:"
echo "   1. Restart Ghostty terminals (close and reopen)"
echo "   2. Restart Neovim (close and reopen, or :Lazy sync)"
echo "   3. Open Wofi (Super+D) to see new theme"
echo "   4. Open Yazi to see new theme"
echo "   5. Open LazyGit to see new theme"
echo "   6. Open Btop to see new theme"
echo ""
echo "🎨 Everforest Dark Theme Applied!"
echo "   Background: #2d353b (deep blue-gray)"
echo "   Accent: #a7c080 (soft green)"
echo "   Foreground: #d3c6aa (warm beige)"