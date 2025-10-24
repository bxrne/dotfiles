#!/bin/bash
# Everforest Dark Theme Colors
# Primary Colors
export EVERFOREST_BG_PRIMARY="#2d353b"      # Deep blue-gray background
export EVERFOREST_BG_SECONDARY="#232a2f"    # Darker background for UI elements
export EVERFOREST_BG_HIGHLIGHT="#424b50"    # Highlighted backgrounds
export EVERFOREST_FG_PRIMARY="#d3c6aa"      # Main foreground (warm beige)
export EVERFOREST_FG_SECONDARY="#859289"    # Secondary foreground (muted gray)

# Accent Colors (Green-focused)
export EVERFOREST_ACCENT="#a7c080"          # Primary green accent
export EVERFOREST_ACCENT_BRIGHT="#b3d39c"   # Brighter green
export EVERFOREST_SUCCESS="#87c095"         # Success green
export EVERFOREST_WARNING="#e69875"         # Soft orange (reduced yellow)
export EVERFOREST_ERROR="#e67e80"           # Soft red

# Additional Colors
export EVERFOREST_BORDER="#4a555b"          # Subtle borders
export EVERFOREST_CURSOR="#d3c6aa"         # Cursor color
export EVERFOREST_SELECTION="#424b50"       # Selection background

# Legacy compatibility
export BG_PRIMARY="$EVERFOREST_BG_PRIMARY"
export BG_SECONDARY="$EVERFOREST_BG_SECONDARY"
export FG_PRIMARY="$EVERFOREST_FG_PRIMARY"
export ACCENT="$EVERFOREST_ACCENT"
export SUCCESS="$EVERFOREST_SUCCESS"
export ERROR="$EVERFOREST_ERROR"