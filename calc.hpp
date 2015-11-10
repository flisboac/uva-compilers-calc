#ifndef CALC_HPP_
#define CALC_HPP_

#include <string>
#include <set>
#include <map>
#include <vector>

namespace calc {

enum class val_e {
	INVALIDO,
	INTEIRO,
	DECIMAL,
	SIMBOLO,
	INDICE
};


class simb {
public:
	simb() = default;
	simb(std::string nome) : _nome(nome) {}
	simb(int valor, std::string nome) : _id(valor), _nome(nome) {}
	int id() const { return _id; }
	std::string nome() const { return _nome; }
private:
	int _id = 0;
	std::string _nome;
};


struct val {
	val_e tipo = val_e::INVALIDO;
	union {
		long inteiro;
		double decimal;
		simb simbolo;
		int indice;
	}
	val() = default;
	val(long v)   : tipo(val_e::INTEIRO) { this->inteiro = v; }
	val(double v) : tipo(val_e::DECIMAL) { this->decimal = v; }
	val(simb v)   : tipo(val_e::SIMBOLO) { this->simbolo = v; }
	val(int v)    : tipo(val_e::INDICE)  { this->indice = v; }
};


class stbl {
public:
	int lookup(simb simbolo) const;
	int lookupInsert(simb simbolo);
	std::vector<simb> nomes() const { return _nomes; }
	std::map<int, simb> indices() const { return _indices; }
private:
	std::vector<simb> _nomes;
	std::map<int, simb> _indices;
};


class expr {
public:
	expr() = default;
	expr(val valor) : _valor(valor) {}
	expr(val valor, expr* filho) : _valor(valor), _dir(filho) {
		filho._pai = this;
	}
	expr(val valor, expr* dir, expr* esq) : _valor(valor), _dir(dir), _esq(esq) {
		dir._pai = this;
		esq._pai = this;
	}
	~expr() {
		delete _dir;
		delete _esq;
	}
	inline val valor() const { return _sim; }
	inline const expr* pai() const { return _pai; }
	inline const expr* filho() const { return _dir ? _dir : _esq; }
	inline const expr* direita() const { return _dir; }
	inline const expr* esquerda() const { return _esq; }
	inline bool israiz() const { return !_pai; }
	inline bool isunaria() const { return (_dir && !_esq) && (!_dir && _esq); }
	inline bool isterminal() const { return !_dir && !_esq; }

private:
	val _valor;
	expr* _pai = nullptr;
	expr* _dir = nullptr;
	expr* _esq = nullptr;
};


class lang {
public:
	lang() = default;
	~lang() {
		delete _resultado;
	}
	const simb& simbolos() const { return _simbolos; }
	expr* resultado() const { return _resultado; }
	void resultado(expr* res) { _resultado = res; }
	int lookup(simb simbolo) const { return _simbolos.lookup(simbolo); }
	int lookupInsert(simb simbolo) const { return _simbolos.lookupInsert(simbolo); }
	expr* terminal(simb simbolo) {
		int indice = _simbolos.lookupInsert(simbolo);
		return (_resultado = new expr(indice));
	}
	boolean abrir(std::FILE* file)
private:
	stbl _simbolos;
	expr* _resultado = nullptr;
};

}

#endif /* CALC_HPP_ */
