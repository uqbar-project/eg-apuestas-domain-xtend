package ar.edu.apuestas

import java.math.BigDecimal
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
abstract class Resultado {
	int ganador

	new(int ganador) {
		this.ganador = ganador
	}

}

class Ganador extends Resultado {
	BigDecimal montoGanado

	new(int ganador, BigDecimal montoGanado) {
		super(ganador)
		this.montoGanado = montoGanado
	}

	override toString() {
		'''Ganaste $«montoGanado»'''
	}
}

class Perdedor extends Resultado {
	new(int ganador) {
		super(ganador)
	}

	override toString() {
		'''Perdiste, salió el «ganador»'''
	}
}
