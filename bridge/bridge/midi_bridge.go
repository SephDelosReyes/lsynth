package main

import (
	"fmt"
	"net"

	"gitlab.com/gomidi/midi/v2"
	"gitlab.com/gomidi/midi/v2/drivers/rtmididrv"
)

func main() {
	drv, err := rtmididrv.New()
	if err != nil {
		panic(err)
	}
	defer drv.Close()

	// get all available midi inputs
	ins, err := drv.Ins()
	if err != nil || len(ins) == 0 {
		panic("No MIDI devices found")
	}

	fmt.Println("MIDI input devices:")

	for i, in := range ins {
		fmt.Printf("%d: %s\n", i, in.String())
	}

	conn, err := net.Dial("udp", "127.0.0.1:9001")
	if err != nil {
		panic(err)
	}

	stop, err := midi.ListenTo(ins[0], func(msg midi.Message, timestampms int32) {
		var bt []byte
		bt = msg.Bytes()

		if len(bt) < 3 {
			return
		}

		// masking for cmd and ch
		command := bt[0] & 0xF0
		channel := bt[0] & 0x0F
		fmt.Printf("Command %X on Channel %d\n", command, channel+1)
		// decode data bytes
		data1 := bt[1]
		data2 := bt[2]

		// idk, maybe find standard transport later
		switch command {
		case 0x90:
			if data2 == 0 {
				fmt.Fprintf(conn, "{type='note_off', note=%d}\n", data1)
			} else {
				fmt.Fprintf(conn, "{type='note_on', note=%d, velocity=%d}\n", data1, data2)
			}
		case 0x80:
			fmt.Fprintf(conn, "{type='note_off', note=%d}\n", data1)
		case 0xB0:
			fmt.Fprintf(conn, "{cc=%d, value=%d}\n", data1, data2)
		}

	})

	if err != nil {
		panic(err)
	}

	defer stop()

	select {}
}
