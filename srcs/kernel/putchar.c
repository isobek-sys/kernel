/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   putchar.c                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: blukasho <bodik1w@gmail.com>               +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2020/04/08 07:45:29 by blukasho          #+#    #+#             */
/*   Updated: 2020/04/08 08:14:15 by blukasho         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <printf.h>

int		putchar(const char c)
{
	PUT(c);

/*
** Control output position
*/

	++__curr_col;
	if (__curr_col == MAX_COL)
	{
		++__curr_row;
		__curr_col &= 0x00;
	}
	if (__curr_row == (MAX_ROW + 1))
		__curr_row &= 0x00;
	return (0);
}
