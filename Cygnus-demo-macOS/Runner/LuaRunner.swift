//
//  LuaRunner.swift
//  Asteroid for mac
//
//  Created by EnchantCode on 2024/03/13.
//

import Foundation
import Cygnus
import CygnusCore

/// Luaコードのランナー
final class LuaRunner {
    
    // MARK: - Properties
    
    /// Luaインスタンス
    private var lua = Lua() {
        didSet {
            Renderer.default.installMethods(to: lua)
        }
    }
    
    /// loop関数を定期的に実行するためのタイマ
    private var loopTimer: Timer?
    
    /// loop関数の実行間隔
    var frameRate: TimeInterval = 0.1
    
    /// デリゲート
    weak var delegate: LuaRunnerDelegate?
    
    // MARK: - Initializers
    
    init(){
        // レンダラの関数をインスタンスに登録
        Renderer.default.installMethods(to: lua)
    }
    
    // MARK: - Public methods
    
    /// ソースコードを読み込む
    /// - Parameter code: コード
    func load(_ code: String) throws {
        // Luaインスタンスを立て直す
        lua = .init()
        
        // 面倒なので丸ごとevalに通す
        try lua.eval(code)
        
        // 関数setup,drawが存在することを確認する
        try lua.getGlobal(name: "setup")
        guard try lua.getType() == .Function else {throw LuaError.FileError("Function setup() not defined or it is not function object")}
        try lua.getGlobal(name: "draw")
        guard try lua.getType() == .Function else {throw LuaError.FileError("Function draw() not defined or it is not function object")}
        try lua.pop(count: 2)
    }
    
    /// 読み込んだLuaコードを実行する
    func run() throws {
        // 関数setupを呼び出す
        try lua.getGlobal(name: "setup")
        try lua.call(argCount: 0, returnCount: 0)
        
        // 関数drawを呼び出すタイマを構成
        loopTimer = .scheduledTimer(withTimeInterval: frameRate, repeats: true, block: {[weak self] timer in
            do {
                // 関数drawを実行 これによりコンテキスト内に描画される
                try self?.lua.getGlobal(name: "draw")
                try self?.lua.call(argCount: 0, returnCount: 0)
                
                // キャンバスを更新
                Renderer.default.updateCanvas()
            } catch {
                // 実行時にエラーになったら止める
                self?.stop(withError: error)
            }
        })
        
        self.delegate?.didStart(self)
    }
    
    /// 実行中のコードを停止する
    /// - Parameter error: 発生したエラー
    func stop(withError error: Error? = nil){
        loopTimer?.invalidate()
        delegate?.didStop(self, withError: error)
    }
    
}
