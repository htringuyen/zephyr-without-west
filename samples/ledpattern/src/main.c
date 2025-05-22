/*
 * Copyright (c) 2016 Intel Corporation
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <stdio.h>
#include <zephyr/device.h>
#include <zephyr/kernel.h>
#include <zephyr/drivers/gpio.h>

#define LED0_NODE DT_ALIAS(led0)
#define LED1_NODE DT_ALIAS(led1)
#define SW0_NODE DT_ALIAS(sw0)

#if !DT_NODE_HAS_STATUS(LED0_NODE, okay)
#error "LED0 is not enabled"
#endif

#if !DT_NODE_HAS_STATUS(LED1_NODE, okay)
#error "LED1 is not enabled"
#endif

#if !DT_NODE_HAS_STATUS(SW0_NODE, okay)
#error "Button SW0 is not enabled"
#endif

static const struct gpio_dt_spec led0 = GPIO_DT_SPEC_GET(LED0_NODE, gpios);
static const struct gpio_dt_spec led1 = GPIO_DT_SPEC_GET(LED1_NODE, gpios);
static const struct gpio_dt_spec button = GPIO_DT_SPEC_GET(SW0_NODE, gpios);

static struct gpio_callback button_cb_data;

// LED blink delays
#define NUM_FREQS 3
static const uint32_t led0_blink_delays[NUM_FREQS] = {1000, 500, 100}; // ms
static const uint32_t led1_blink_delays[NUM_FREQS] = {100, 500, 1000}; // ms
static uint8_t current_delay_idx = 0;

#define LED0_STACK_SIZE 512
#define LED1_STACK_SIZE 512
#define LED0_PRIORITY 5
#define LED1_PRIORITY 5

struct led_data {
	char *name;
	const struct gpio_dt_spec *led;
	uint32_t *blink_delay;
};

static struct led_data led0_data;
static struct led_data led1_data;

K_THREAD_STACK_DEFINE(led0_stack, LED0_STACK_SIZE);
K_THREAD_STACK_DEFINE(led1_stack, LED1_STACK_SIZE);

struct k_thread led0_thread;
struct k_thread led1_thread;
k_tid_t led0_tid;
k_tid_t led1_tid;

void led_thread_run(void *arg1, void *arg2, void *arg3) {
	struct led_data *data = (struct led_data *) arg1;
	const struct gpio_dt_spec *led = data->led;
	uint32_t *blink_delay = data->blink_delay;
	uint8_t is_led_on = 0;
	while (1) {
		is_led_on = !is_led_on;
		gpio_pin_set_dt(led, is_led_on);
		printf("%s being %s [%d ms]\n", data->name, is_led_on ? "ON" : "OFF", *blink_delay);
		k_msleep(*blink_delay);
	}
}

void on_button_pressed(const struct device *dev, struct gpio_callback *cb, uint32_t pins) {
	current_delay_idx = (current_delay_idx + 1) % NUM_FREQS;
	printf("Changing blink delay to %d and %d ms\n", 
		led0_blink_delays[current_delay_idx], led1_blink_delays[current_delay_idx]);
}

int main(void) {
	int ret = 0;
	uint32_t led0_delay = led0_blink_delays[current_delay_idx];
	uint32_t led1_delay = led1_blink_delays[current_delay_idx];

	// check device nodes
	if (!gpio_is_ready_dt(&led0) || !gpio_is_ready_dt(&led1)) {
		printf("Error: LEDs not ready\n");
		return ret;
	}

	if (!gpio_is_ready_dt(&button)) {
		printf("Error: Button not ready\n");
		return ret;
	}

	// configure leds as outputs
	ret = gpio_pin_configure_dt(&led0, GPIO_OUTPUT_INACTIVE);
	if (ret < 0) {
		printf("Error %d: failed to configure LED0\n", ret);
		return ret;
	}
	ret = gpio_pin_configure_dt(&led1, GPIO_OUTPUT_INACTIVE);
	if (ret < 0) {
		printf("Error %d: failed to configure LED1\n", ret);
		return ret;
	}

	// configure button as input with interrupt
	ret = gpio_pin_configure_dt(&button, GPIO_INPUT);
	if (ret < 0) {
		printf("Error %d: failed to configure button\n", ret);
		return ret;
	}
	ret = gpio_pin_interrupt_configure_dt(&button, GPIO_INT_EDGE_TO_ACTIVE);
	if (ret < 0) {
		printf("Error %d: failed to configure interrupt\n", ret);
		return ret;
	}

	// configure interrupt callback function
	gpio_init_callback(&button_cb_data, on_button_pressed, BIT(button.pin));
	gpio_add_callback(button.port, &button_cb_data);

	printf("Starting blinky app with initial blink delays %d and %d ms\n", 
		led0_blink_delays[current_delay_idx], led1_blink_delays[current_delay_idx]);

	// initialize LED data
	led0_data.name = "LED0";
	led0_data.led = &led0;
	led0_data.blink_delay = &led0_delay;

	led1_data.name = "LED1";
	led1_data.led = &led1;
	led1_data.blink_delay = &led1_delay;

	// create LED threads
	led0_tid = k_thread_create(&led0_thread, led0_stack, LED0_STACK_SIZE, 
		led_thread_run, &led0_data, NULL, NULL, 
		LED0_PRIORITY, 0, K_NO_WAIT);

	led1_tid = k_thread_create(&led1_thread, led1_stack, LED1_STACK_SIZE, 
		led_thread_run, &led1_data, NULL, NULL, 
		LED1_PRIORITY, 0, K_NO_WAIT);

	while (1) {
		led0_delay = led0_blink_delays[current_delay_idx];
		led1_delay = led1_blink_delays[current_delay_idx];
		k_msleep(100);
	}

	return ret;
}
