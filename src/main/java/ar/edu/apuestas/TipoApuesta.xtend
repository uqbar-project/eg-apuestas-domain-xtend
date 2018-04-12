package ar.edu.apuestas

import java.math.BigDecimal
import java.util.List
import org.uqbar.commons.model.annotations.Observable
import org.uqbar.commons.model.exceptions.UserException

@Observable
abstract class TipoApuesta {
	def List<Object> getValoresPosibles()
	def int montoMinimo()
	def int ganancia()
	def String getNombre()
	def boolean esGanador(int ganador, Object valorApostado)

	def validarMontoMinimo(BigDecimal monto) {
		if (monto < new BigDecimal(montoMinimo)) {
			throw new UserException('''El monto minimo para una apuesta «this» es «montoMinimo»''')
		}
	}

	def Resultado chequearApuesta(int ganador, Apuesta apuesta) {
		if (esGanador(ganador, apuesta.valorApostado))
			new Ganador(ganador, apuesta.monto * new BigDecimal(ganancia))
		else
			new Perdedor(ganador)
	}

	def asObjects(List<?> list) {
		list.map[it as Object]
	}
}

class ApuestaPleno extends TipoApuesta {
	override getValoresPosibles() {
		(1 .. 36).toList.asObjects
	}

	override montoMinimo() {
		10
	}

	override ganancia() {
		35
	}

	override esGanador(int ganador, Object valorApostado) {
		ganador == valorApostado
	}
	
	override getNombre() {
		"Pleno"
	}
	
}

class ApuestaDocena extends TipoApuesta {
	val docenas = #["Primera", "Segunda", "Tercera"]

	override getValoresPosibles() {
		docenas.asObjects
	}

	override montoMinimo() {
		50
	}

	override ganancia() {
		11
	}

	override esGanador(int ganador, Object valorApostado) {
		val docena = docenas.indexOf(valorApostado)
		val min = docena * 12 + 1
		val max = (docena + 1) * 12
		(min .. max).contains(ganador)
	}
	
	override getNombre() {
		"Docena"
	}
	
}
