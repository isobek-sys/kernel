/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   screen.h                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: blukasho <bodik1w@gmail.com>               +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2020/04/07 08:41:44 by blukasho          #+#    #+#             */
/*   Updated: 2020/04/07 14:00:58 by blukasho         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef SCREEN_H
# define SCREEN_H

/*
** Default VGA memory in CPU address space start 0xB8000 end 0xBFFFF 32K
*/

# define VGA_MEM 0xB8000 

/*
** Size of print matrix
*/

# define MAX_COL 80
# define MAX_ROW 25

/*
** Blinking 0x1 - on, 0x0 - off
*/

# define BLINK 0x0

/*
** All print colors
*/

# define BLACK			0x0
# define BLUE			0x1
# define GREEN			0x2
# define CYAN			0x3
# define RED			0x4
# define MAGENTA		0x5
# define BROWN			0x6
# define GRAY			0x7
# define DARK_GREY		0x8
# define BRIGHT_BLUE	0x9
# define BRIGHT_GREEN	0xA
# define BRIGHT_CYAN	0xB
# define BRIGHT_RED		0xC
# define BRIGHT_MAGENTA	0xD
# define YELLOW			0xE
# define WHITE			0xF

/*
** Default print colors
*/

# define BACKGROUND_COLOR	0x1
# define SYMBOL_COLOR		0xF
# define DEFAULT_COLOR		(((((0x00 | BLINK) << 3) | BACKGROUND_COLOR) << 4) | SYMBOL_COLOR)

static unsigned short	__curr_col;
static unsigned short	__curr_row;

# define PUT(c) (((unsigned short *) VGA_MEM)[__curr_row * MAX_COL + \
						__curr_col] = (DEFAULT_COLOR << 8) | (c))

#endif
