/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   screen.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: blukasho <bodik1w@gmail.com>               +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2020/04/08 08:16:20 by blukasho          #+#    #+#             */
/*   Updated: 2020/04/08 08:25:34 by blukasho         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <screen.h>

void	clear_screen(void)
{
	__curr_col &= 0x00;
	__curr_row &= 0x00;
	while (__curr_row <= (MAX_ROW + 1))
	{
		PUT(' ');
		++__curr_col;
		if (__curr_col == MAX_COL)
		{
			__curr_col &= 0x00;
			++__curr_row;
		}
	}
	__curr_col &= 0x00;
	__curr_row &= 0x00;
}
