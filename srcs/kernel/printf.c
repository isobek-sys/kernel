/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   printf.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: blukasho <bodik1w@gmail.com>               +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2020/04/06 19:25:03 by blukasho          #+#    #+#             */
/*   Updated: 2020/04/08 08:24:32 by blukasho         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <printf.h>

int			printf(const char *format, ...)
{
	while (*format)
		putchar(*(format++));
	return (0);
}
