/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   printf.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: blukasho <bodik1w@gmail.com>               +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2020/04/06 19:25:03 by blukasho          #+#    #+#             */
/*   Updated: 2020/04/07 13:06:44 by blukasho         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <printf.h>

int		printf(const char *format, ...)
{
	while (__curr_col < MAX_COL && __curr_row < MAX_ROW)
	{
		PUT('*');
		++__curr_col;
		if (__curr_col == MAX_COL)
		{
			__curr_col = 0;
			++__curr_row;
		}
	}
	return (0);
}
